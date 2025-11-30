import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../authentication/auth_repository.dart';

import '../sync/sync_manager.dart';

part 'sticky_note_repository.g.dart';

class StickyNote {
  final String id;
  final String bookId;
  final int pageIndex; // Page index where the note is attached
  final double x; // Relative X position (0.0 to 1.0)
  final double y; // Relative Y position (0.0 to 1.0)
  final String content;
  final String color; // Hex color string
  final String authorId;
  final String authorName;
  final DateTime createdAt;

  StickyNote({
    required this.id,
    required this.bookId,
    required this.pageIndex,
    required this.x,
    required this.y,
    required this.content,
    required this.color,
    required this.authorId,
    required this.authorName,
    required this.createdAt,
  });

  factory StickyNote.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StickyNote(
      id: doc.id,
      bookId: data['bookId'] ?? '',
      pageIndex: data['pageIndex'] ?? 0,
      x: (data['x'] ?? 0.0).toDouble(),
      y: (data['y'] ?? 0.0).toDouble(),
      content: data['content'] ?? '',
      color: data['color'] ?? '0xFFFFF59D', // Default yellow
      authorId: data['authorId'] ?? '',
      authorName: data['authorName'] ?? 'Unknown',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookId': bookId,
      'pageIndex': pageIndex,
      'x': x,
      'y': y,
      'content': content,
      'color': color,
      'authorId': authorId,
      'authorName': authorName,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}

class StickyNoteRepository {
  final FirebaseFirestore _firestore;
  final String? _currentUserId;
  final String? _currentUserName;

  final SyncQueueService _syncQueue;

  StickyNoteRepository(
    this._firestore,
    this._currentUserId,
    this._currentUserName,
    this._syncQueue,
  );

  // Stream notes for a specific book owned by a specific user (could be me or a friend)
  Stream<List<StickyNote>> watchNotes({
    required String ownerId,
    required String bookId,
  }) {
    return _firestore
        .collection('users')
        .doc(ownerId)
        .collection('text_books')
        .doc(bookId)
        .collection('notes')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => StickyNote.fromFirestore(doc)).toList();
    });
  }

  Future<void> addNote({
    required String ownerId,
    required String bookId,
    required int pageIndex,
    required double x,
    required double y,
    required String content,
    required String color,
  }) async {
    if (_currentUserId == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(ownerId)
          .collection('text_books')
          .doc(bookId)
          .collection('notes')
          .add({
        'bookId': bookId,
        'pageIndex': pageIndex,
        'x': x,
        'y': y,
        'content': content,
        'color': color,
        'authorId': _currentUserId,
        'authorName': _currentUserName ?? 'Unknown',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      await _syncQueue.addToQueue('SYNC_STICKY_NOTE', {
        'action': 'add',
        'ownerId': ownerId,
        'bookId': bookId,
        'pageIndex': pageIndex,
        'x': x,
        'y': y,
        'content': content,
        'color': color,
      });
    }
  }

  Future<void> updateNote({
    required String ownerId,
    required String bookId,
    required String noteId,
    String? content,
    double? x,
    double? y,
    String? color,
  }) async {
    final updates = <String, dynamic>{};
    if (content != null) updates['content'] = content;
    if (x != null) updates['x'] = x;
    if (y != null) updates['y'] = y;
    if (color != null) updates['color'] = color;

    if (updates.isEmpty) return;

    try {
      await _firestore
          .collection('users')
          .doc(ownerId)
          .collection('text_books')
          .doc(bookId)
          .collection('notes')
          .doc(noteId)
          .update(updates);
    } catch (e) {
      await _syncQueue.addToQueue('SYNC_STICKY_NOTE', {
        'action': 'update',
        'ownerId': ownerId,
        'bookId': bookId,
        'noteId': noteId,
        'updates': updates,
      });
    }
  }

  Future<void> deleteNote({
    required String ownerId,
    required String bookId,
    required String noteId,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(ownerId)
          .collection('text_books')
          .doc(bookId)
          .collection('notes')
          .doc(noteId)
          .delete();
    } catch (e) {
      await _syncQueue.addToQueue('SYNC_STICKY_NOTE', {
        'action': 'delete',
        'ownerId': ownerId,
        'bookId': bookId,
        'noteId': noteId,
      });
    }
  }

  // Helper for SyncWorker to retry operations
  Future<void> syncNoteOperation(Map<String, dynamic> payload) async {
    final action = payload['action'] as String;
    final ownerId = payload['ownerId'] as String;
    final bookId = payload['bookId'] as String;

    if (action == 'add') {
      await _firestore
          .collection('users')
          .doc(ownerId)
          .collection('text_books')
          .doc(bookId)
          .collection('notes')
          .add({
        'bookId': bookId,
        'pageIndex': payload['pageIndex'],
        'x': payload['x'],
        'y': payload['y'],
        'content': payload['content'],
        'color': payload['color'],
        'authorId': _currentUserId,
        'authorName': _currentUserName ?? 'Unknown',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } else if (action == 'update') {
      final noteId = payload['noteId'] as String;
      final updates = Map<String, dynamic>.from(payload['updates']);
      await _firestore
          .collection('users')
          .doc(ownerId)
          .collection('text_books')
          .doc(bookId)
          .collection('notes')
          .doc(noteId)
          .update(updates);
    } else if (action == 'delete') {
      final noteId = payload['noteId'] as String;
      await _firestore
          .collection('users')
          .doc(ownerId)
          .collection('text_books')
          .doc(bookId)
          .collection('notes')
          .doc(noteId)
          .delete();
    }
  }
}

@Riverpod(keepAlive: true)
StickyNoteRepository stickyNoteRepository(StickyNoteRepositoryRef ref) {
  final user = ref.watch(authRepositoryProvider).currentUser;
  final syncQueue = ref.watch(syncQueueServiceProvider);
  // We might need to fetch display name if it's not in currentUser immediately,
  // but for now currentUser.displayName is the best bet.
  return StickyNoteRepository(
    FirebaseFirestore.instance,
    user?.uid,
    user?.displayName,
    syncQueue,
  );
}

@riverpod
Stream<List<StickyNote>> stickyNotesStream(
  StickyNotesStreamRef ref, {
  required String ownerId,
  required String bookId,
}) {
  return ref
      .watch(stickyNoteRepositoryProvider)
      .watchNotes(ownerId: ownerId, bookId: bookId);
}
