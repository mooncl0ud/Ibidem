import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../authentication/auth_repository.dart';
import 'inbox_item.dart';

part 'inbox_repository.g.dart';

class InboxRepository {
  final FirebaseFirestore _firestore;
  final String? _userId;

  InboxRepository(this._firestore, this._userId);

  Stream<List<InboxItem>> watchInbox() {
    if (_userId == null) return Stream.value([]);
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('inbox')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => InboxItem.fromFirestore(doc)).toList());
  }

  Stream<int> watchUnreadCount() {
    if (_userId == null) return Stream.value(0);
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('inbox')
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Future<void> markAsRead(String itemId) async {
    if (_userId == null) return;
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('inbox')
        .doc(itemId)
        .update({'isRead': true});
  }
}

@Riverpod(keepAlive: true)
InboxRepository inboxRepository(InboxRepositoryRef ref) {
  final user = ref.watch(authRepositoryProvider).currentUser;
  return InboxRepository(FirebaseFirestore.instance, user?.uid);
}

@riverpod
Stream<int> unreadInboxCount(UnreadInboxCountRef ref) {
  return ref.watch(inboxRepositoryProvider).watchUnreadCount();
}
