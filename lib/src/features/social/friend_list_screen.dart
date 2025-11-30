import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/theme/app_typography.dart';
import '../../shared/widgets/empty_state_widget.dart';
import 'social_repository.dart';

class FriendListScreen extends ConsumerStatefulWidget {
  const FriendListScreen({super.key});

  @override
  ConsumerState<FriendListScreen> createState() => _FriendListScreenState();
}

class _FriendListScreenState extends ConsumerState<FriendListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchUsers() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() => _isSearching = true);
    try {
      final results = await ref
          .read(socialRepositoryProvider)
          .searchUsers(query);
      setState(() => _searchResults = results);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('검색 실패: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }

  void _showAddFriendDialog() {
    // Focus on the search field
    // This is a simple implementation, ideally we might want to highlight the search bar
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('상단의 검색창을 이용해 친구를 찾아보세요.')));
  }

  @override
  Widget build(BuildContext context) {
    final pendingRequestsAsync = ref.watch(pendingRequestsProvider);
    final friendsAsync = ref.watch(friendsListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('친구 관리')),
      body: Column(
        children: [
          // Search Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: '이메일로 친구 검색',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                    ),
                    onSubmitted: (_) => _searchUsers(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _searchUsers,
                  icon: _isSearching
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.search),
                ),
              ],
            ),
          ),

          // Search Results
          if (_searchResults.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '검색 결과',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final user = _searchResults[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user['photoURL'] != null
                        ? NetworkImage(user['photoURL'])
                        : null,
                    child: user['photoURL'] == null
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  title: Text(user['displayName'] ?? 'Unknown'),
                  subtitle: Text(user['email'] ?? ''),
                  trailing: IconButton(
                    icon: const Icon(Icons.person_add),
                    onPressed: () async {
                      try {
                        await ref
                            .read(socialRepositoryProvider)
                            .sendFriendRequest(user['uid']);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('친구 요청을 보냈습니다.')),
                          );
                          setState(() => _searchResults = []);
                          _searchController.clear();
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text('요청 실패: $e')));
                        }
                      }
                    },
                  ),
                );
              },
            ),
            const Divider(),
          ],

          // Pending Requests
          pendingRequestsAsync.when(
            data: (requests) {
              if (requests.isEmpty) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      '받은 요청',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final request = requests[index];
                      final sender = request['sender'] as Map<String, dynamic>?;
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: sender?['photoURL'] != null
                              ? NetworkImage(sender!['photoURL'])
                              : null,
                          child: sender?['photoURL'] == null
                              ? const Icon(Icons.person)
                              : null,
                        ),
                        title: Text(sender?['displayName'] ?? 'Unknown'),
                        subtitle: Text(sender?['email'] ?? ''),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                              onPressed: () {
                                ref
                                    .read(socialRepositoryProvider)
                                    .acceptFriendRequest(
                                      request['id'],
                                      request['from'],
                                    );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () {
                                ref
                                    .read(socialRepositoryProvider)
                                    .rejectFriendRequest(request['id']);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const Divider(),
                ],
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          // Friends List
          Expanded(
            child: friendsAsync.when(
              data: (friends) {
                if (friends.isEmpty) {
                  return EmptyStateWidget(
                    icon: Icons.people_outline,
                    message: '친구가 없습니다',
                    subMessage: '이메일로 친구를 검색하여 추가해보세요',
                    onAction: () => _showAddFriendDialog(),
                    actionLabel: '친구 추가하기',
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        '내 친구',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: friends.length,
                        itemBuilder: (context, index) {
                          final friend = friends[index];
                          return ListTile(
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
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
