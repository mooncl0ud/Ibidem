import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../authentication/auth_repository.dart';

part 'social_repository.g.dart';

class SocialRepository {
  final FirebaseFirestore _firestore;
  final String? _currentUserId;

  SocialRepository(this._firestore, this._currentUserId);

  Future<List<Map<String, dynamic>>> searchUsers(String email) async {
    if (email.isEmpty) return [];

    final snapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['uid'] = doc.id;
      return data;
    }).toList();
  }

  Future<void> sendFriendRequest(String toUserId) async {
    if (_currentUserId == null) return;

    // Check if request already exists
    final existing = await _firestore
        .collection('friend_requests')
        .where('from', isEqualTo: _currentUserId)
        .where('to', isEqualTo: toUserId)
        .get();

    if (existing.docs.isNotEmpty) return;

    await _firestore.collection('friend_requests').add({
      'from': _currentUserId,
      'to': toUserId,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> acceptFriendRequest(String requestId, String fromUserId) async {
    if (_currentUserId == null) return;

    final batch = _firestore.batch();

    // 1. Add to my friends
    final myFriendRef = _firestore
        .collection('users')
        .doc(_currentUserId)
        .collection('friends')
        .doc(fromUserId);
    batch.set(myFriendRef, {'createdAt': FieldValue.serverTimestamp()});

    // 2. Add me to their friends
    final theirFriendRef = _firestore
        .collection('users')
        .doc(fromUserId)
        .collection('friends')
        .doc(_currentUserId);
    batch.set(theirFriendRef, {'createdAt': FieldValue.serverTimestamp()});

    // 3. Delete request
    final requestRef = _firestore.collection('friend_requests').doc(requestId);
    batch.delete(requestRef);

    await batch.commit();
  }

  Future<void> rejectFriendRequest(String requestId) async {
    await _firestore.collection('friend_requests').doc(requestId).delete();
  }

  Stream<List<Map<String, dynamic>>> watchPendingRequests() {
    if (_currentUserId == null) return Stream.value([]);

    return _firestore
        .collection('friend_requests')
        .where('to', isEqualTo: _currentUserId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .asyncMap((snapshot) async {
          final requests = <Map<String, dynamic>>[];
          for (final doc in snapshot.docs) {
            final data = doc.data();
            data['id'] = doc.id;

            // Fetch sender info
            final senderDoc = await _firestore
                .collection('users')
                .doc(data['from'])
                .get();
            if (senderDoc.exists) {
              data['sender'] = senderDoc.data();
            }
            requests.add(data);
          }
          return requests;
        });
  }

  Stream<List<Map<String, dynamic>>> watchFriends() {
    if (_currentUserId == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(_currentUserId)
        .collection('friends')
        .snapshots()
        .asyncMap((snapshot) async {
          final friends = <Map<String, dynamic>>[];
          for (final doc in snapshot.docs) {
            final friendId = doc.id;
            final friendDoc = await _firestore
                .collection('users')
                .doc(friendId)
                .get();
            if (friendDoc.exists) {
              final data = friendDoc.data()!;
              data['uid'] = friendId;
              friends.add(data);
            }
          }
          return friends;
        });
  }
}

@Riverpod(keepAlive: true)
SocialRepository socialRepository(SocialRepositoryRef ref) {
  final user = ref.watch(authRepositoryProvider).currentUser;
  return SocialRepository(FirebaseFirestore.instance, user?.uid);
}

@riverpod
Stream<List<Map<String, dynamic>>> pendingRequests(PendingRequestsRef ref) {
  return ref.watch(socialRepositoryProvider).watchPendingRequests();
}

@riverpod
Stream<List<Map<String, dynamic>>> friendsList(FriendsListRef ref) {
  return ref.watch(socialRepositoryProvider).watchFriends();
}
