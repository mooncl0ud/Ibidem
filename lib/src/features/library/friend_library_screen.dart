import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:go_router/go_router.dart';
import '../../shared/theme/app_typography.dart';
import '../library/text_book_repository.dart';

class FriendLibraryScreen extends ConsumerStatefulWidget {
  final String friendId;
  final String friendName;

  const FriendLibraryScreen({
    super.key,
    required this.friendId,
    required this.friendName,
  });

  @override
  ConsumerState<FriendLibraryScreen> createState() =>
      _FriendLibraryScreenState();
}

class _FriendLibraryScreenState extends ConsumerState<FriendLibraryScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _books = [];

  @override
  void initState() {
    super.initState();
    _loadFriendBooks();
  }

  Future<void> _loadFriendBooks() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.friendId)
          .collection('text_books')
          .get();

      setState(() {
        _books = snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('책 목록을 불러오는데 실패했습니다: $e')));
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _openBook(Map<String, dynamic> bookData) async {
    final downloadUrl = bookData['filePath'] as String?;
    if (downloadUrl == null || !downloadUrl.startsWith('http')) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('이 책은 다운로드할 수 없습니다.')));
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      final String title = bookData['title'] ?? 'Unknown Title';
      final String sourceId = bookData['id']; // Document ID from Firestore
      final String ownerId = widget.friendId;

      // Download file to temp directory
      final response = await http.get(Uri.parse(downloadUrl));
      if (response.statusCode != 200) {
        throw Exception('Failed to download book');
      }

      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/$title.txt');
      await tempFile.writeAsBytes(response.bodyBytes);

      if (!mounted) return;

      // Import as shared book (tracks progress locally & syncs)
      final book = await ref
          .read(textBookRepositoryProvider)
          .importSharedBook(tempFile, title, sourceId, ownerId);

      if (!mounted) return;

      // Navigate to reader
      context.push('/reader/${book.id}');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error opening book: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.friendName}의 서재')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _books.isEmpty
          ? const Center(child: Text('공유된 책이 없습니다.'))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2 / 3.5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 24,
              ),
              itemCount: _books.length,
              itemBuilder: (context, index) {
                final book = _books[index];
                return GestureDetector(
                  onTap: () => _openBook(book),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.description,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        book['title'] ?? 'Unknown',
                        style: AppTypography.h2.copyWith(fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
