import 'package:cloud_firestore/cloud_firestore.dart';

class InboxItem {
  final String id;
  final String senderId;
  final String senderName;
  final String message;
  final String type; // 'note', 'friend_request', etc.
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic>? data; // Extra data like bookId, noteId

  InboxItem({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.data,
  });

  factory InboxItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return InboxItem(
      id: doc.id,
      senderId: data['senderId'] ?? '',
      senderName: data['senderName'] ?? 'Unknown',
      message: data['message'] ?? '',
      type: data['type'] ?? 'notification',
      isRead: data['isRead'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      data: data['data'],
    );
  }
}
