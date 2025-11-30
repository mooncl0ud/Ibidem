import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/theme/app_typography.dart';
import '../../shared/widgets/empty_state_widget.dart';
import 'text_book_repository.dart';
import '../social/inbox_screen.dart';
import '../social/friend_list_screen.dart';
import '../social/social_repository.dart';
import 'friend_library_screen.dart';
import '../social/inbox_repository.dart';
import '../authentication/auth_repository.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Trigger sync on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(textBookRepositoryProvider).syncBooksFromCloud();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _importBook() async {
    try {
      final book = await ref.read(textBookRepositoryProvider).importTextFile();
      if (book != null && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${book.title} 추가됨')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('책 가져오기 실패: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('IBIDEM'),
          actions: [
            IconButton(
              icon: const Icon(Icons.people),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FriendListScreen(),
                  ),
                );
              },
            ),
            Consumer(
              builder: (context, ref, child) {
                final unreadCountAsync = ref.watch(unreadInboxCountProvider);
                return IconButton(
                  icon: unreadCountAsync.when(
                    data: (count) => Badge(
                      isLabelVisible: count > 0,
                      label: Text('$count'),
                      child: Icon(
                        count > 0
                            ? Icons.notifications
                            : Icons.notifications_none,
                      ),
                    ),
                    loading: () => const Icon(Icons.notifications_none),
                    error: (_, __) => const Icon(Icons.notifications_none),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const InboxScreen()),
                    );
                  },
                );
              },
            ),
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'logout') {
                  // Wait for popup menu to close completely
                  await Future.delayed(Duration.zero);
                  if (!context.mounted) return;

                  final shouldLogout = await showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder: (dialogContext) => AlertDialog(
                      title: const Text('로그아웃'),
                      content: const Text('정말 로그아웃 하시겠습니까?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext, false),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey,
                          ),
                          child: const Text('취소'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(dialogContext, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('로그아웃'),
                        ),
                      ],
                    ),
                  );

                  if (shouldLogout == true) {
                    await ref.read(authRepositoryProvider).signOut();
                  }
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: Colors.red),
                        SizedBox(width: 8),
                        Text('로그아웃', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ];
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(100),
            child: Column(
              children: [
                const TabBar(
                  indicatorColor: AppColors.brandOrange,
                  labelColor: AppColors.brandOrange,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(text: '내 서재'),
                    Tab(text: '공유 서재'),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: '책 검색...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() => _searchQuery = value.toLowerCase());
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _PrivateLibraryTab(
              searchQuery: _searchQuery,
              onImport: _importBook,
            ),
            const _SharedLibraryTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _importBook,
          backgroundColor: AppColors.brandOrange,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}

class _PrivateLibraryTab extends ConsumerWidget {
  final String searchQuery;
  final VoidCallback onImport;

  const _PrivateLibraryTab({required this.searchQuery, required this.onImport});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsync = ref.watch(textBooksProvider);

    return booksAsync.when(
      data: (books) {
        final filteredBooks = searchQuery.isEmpty
            ? books
            : books.where((book) {
                return book.title.toLowerCase().contains(searchQuery) ||
                    (book.author?.toLowerCase().contains(searchQuery) ?? false);
              }).toList();

        if (filteredBooks.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.library_books_outlined,
            message: searchQuery.isEmpty ? '내 서재가 비어있습니다.' : '검색 결과가 없습니다.',
            subMessage: searchQuery.isEmpty ? 'TXT 파일을 추가하여 독서를 시작해보세요' : null,
            onAction: searchQuery.isEmpty ? onImport : null,
            actionLabel: searchQuery.isEmpty ? '책 추가하기' : null,
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
          itemCount: filteredBooks.length,
          itemBuilder: (context, index) {
            final book = filteredBooks[index];
            return GestureDetector(
              onTap: () {
                context.push('/reader/${book.id}');
              },
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('책 삭제'),
                    content: Text("'${book.title}'을(를) 삭제하시겠습니까?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('취소'),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          try {
                            await ref
                                .read(textBookRepositoryProvider)
                                .deleteBook(book);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('책이 삭제되었습니다.')),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('삭제 실패: $e')),
                              );
                            }
                          }
                        },
                        child: const Text(
                          '삭제',
                          style: TextStyle(color: AppColors.warningRed),
                        ),
                      ),
                    ],
                  ),
                );
              },
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
                          if (book.encoding != 'UTF-8')
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
                                  book.encoding,
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
                    book.title,
                    style: AppTypography.h2.copyWith(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${(book.fileSizeBytes / 1024).toStringAsFixed(1)} KB',
                    style: AppTypography.caption.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}

class _SharedLibraryTab extends ConsumerWidget {
  const _SharedLibraryTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsAsync = ref.watch(friendsListProvider);

    return friendsAsync.when(
      data: (friends) {
        if (friends.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.people_outline,
            message: '친구가 없습니다.',
            subMessage: '친구를 추가하고 서재를 공유해보세요',
            onAction: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FriendListScreen(),
                ),
              );
            },
            actionLabel: '친구 찾기',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: friends.length,
          itemBuilder: (context, index) {
            final friend = friends[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: friend['photoURL'] != null
                      ? NetworkImage(friend['photoURL'])
                      : null,
                  child: friend['photoURL'] == null
                      ? const Icon(Icons.person)
                      : null,
                ),
                title: Text(friend['displayName'] ?? 'Unknown'),
                subtitle: Text(friend['email'] ?? ''),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FriendLibraryScreen(
                        friendId: friend['uid'],
                        friendName: friend['displayName'] ?? 'Unknown',
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
