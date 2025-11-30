import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/theme/app_typography.dart';
import '../../shared/widgets/empty_state_widget.dart';
import '../library/text_book_repository.dart';

class FriendLibraryScreen extends ConsumerWidget {
  final String friendId;
  final String friendName;

  const FriendLibraryScreen({
    super.key,
    required this.friendId,
    required this.friendName,
  });

  Future<void> _openSharedBook(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> bookData,
  ) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final String downloadUrl = bookData['downloadUrl'] ?? '';
      if (downloadUrl.isEmpty) {
        throw Exception('Download URL is empty');
      }

      // Download file
      final response = await http.get(Uri.parse(downloadUrl));
      if (response.statusCode != 200) {
        throw Exception('Failed to download file: ${response.statusCode}');
      }

      final tempDir = await getTemporaryDirectory();
      final fileName = '${bookData['id']}.txt';
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(response.bodyBytes);

      final importedBook = await ref
          .read(textBookRepositoryProvider)
          .importSharedBook(
            file,
            bookData['title'] ?? 'Untitled',
            bookData['id'], // sourceId
            friendId, // ownerId
          );

      if (context.mounted) {
        Navigator.pop(context); // Dismiss loading
        context.push('/reader/${importedBook.id}');
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Dismiss loading
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('책 열기 실패: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('$friendName의 서재')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(friendId)
            .collection('shared_books')
            .orderBy('sharedAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('오류 발생: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.library_books_outlined,
              message: '공유된 책이 없습니다',
              subMessage: '친구가 아직 책을 공유하지 않았습니다',
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2 / 3.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 24,
            ),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              // Add ID to data for easier access
              data['id'] = docs[index].id;

              return GestureDetector(
                onTap: () => _openSharedBook(context, ref, data),
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
                        child: Stack(
                          children: [
                            const Center(
                              child: Icon(
                                Icons.description,
                                size: 40,
                                color: Colors.grey,
                              ),
                            ),
                            if (data['encoding'] != 'UTF-8' &&
                                data['encoding'] != null)
                              Positioned(
                                top: 4,
                                right: 4,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.brandOrange,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: Text(
                                    data['encoding'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      data['title'] ?? 'Untitled',
                      style: AppTypography.h2.copyWith(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${((data['sizeBytes'] ?? 0) / 1024).toStringAsFixed(1)} KB',
                      style: AppTypography.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
