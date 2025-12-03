import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../data/local/local_database_provider.dart';
import '../../data/local/schema/sticky_note_schema.dart';
import '../authentication/auth_repository.dart';
import '../sync/sync_manager.dart';

part 'sticky_note_repository.g.dart';

class StickyNote {
  final String id;
  final String bookId;
  final int pageIndex;
  final double x;
  final double y;
  final String content;
  final String color;
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

  factory StickyNote.fromEntity(StickyNoteEntity entity) {
    return StickyNote(
      id: entity.firestoreId,
      bookId: entity.bookId,
      pageIndex: entity.pageIndex,
      x: entity.x,
      y: entity.y,
      content: entity.content,
      color: entity.color,
      authorId: entity.authorId,
      authorName: entity.authorName,
      createdAt: entity.createdAt,
    );
  }
}

class StickyNoteRepository {
  final FirebaseFirestore _firestore;
  final Isar _isar;
  final String? _currentUserId;
  final String? _currentUserName;
  final SyncQueueService _syncQueue;

  StickyNoteRepository(
    this._firestore,
    this._isar,
    this._currentUserId,
    this._currentUserName,
    this._syncQueue,
  );

  Stream<List<StickyNote>> watchNotes({
    required String ownerId,
    required String bookId,
  }) {
    // Start listening to Firestore changes in the background
    _syncFromFirestore(ownerId, bookId);

    // Return stream from Isar
    return _isar.stickyNoteEntitys
        .filter()
        .bookIdEqualTo(bookId)
        .and()
        .isDeletedEqualTo(false)
        .watch(fireImmediately: true)
        .map((entities) =>
            entities.map((e) => StickyNote.fromEntity(e)).toList());
  }

  void _syncFromFirestore(String ownerId, String bookId) {
    _firestore
        .collection('users')
        .doc(ownerId)
        .collection('text_books')
        .doc(bookId)
        .collection('notes')
        .snapshots()
        .listen((snapshot) async {
      await _isar.writeTxn(() async {
        for (final doc in snapshot.docChanges) {
          final data = doc.doc.data();
          if (data == null) continue;

          final firestoreId = doc.doc.id;

          if (doc.type == DocumentChangeType.removed) {
            await _isar.stickyNoteEntitys
                .filter()
                .firestoreIdEqualTo(firestoreId)
                .deleteAll();
          } else {
            final existing = await _isar.stickyNoteEntitys
                .filter()
                .firestoreIdEqualTo(firestoreId)
                .findFirst();

            final entity = existing ?? StickyNoteEntity();
            entity.firestoreId = firestoreId;
            entity.bookId = data['bookId'] ?? bookId;
            entity.pageIndex = data['pageIndex'] ?? 0;
            entity.x = (data['x'] ?? 0.0).toDouble();
            entity.y = (data['y'] ?? 0.0).toDouble();
            entity.content = data['content'] ?? '';
            entity.color = data['color'] ?? '0xFFFFF59D';
            entity.authorId = data['authorId'] ?? '';
            entity.authorName = data['authorName'] ?? 'Unknown';
            entity.createdAt =
                (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
            entity.isSynced = true;
            entity.isDeleted = false;

            await _isar.stickyNoteEntitys.put(entity);
          }
        }
      });
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

    final uuid = const Uuid().v4();
    final now = DateTime.now();

    final entity = StickyNoteEntity()
      ..firestoreId = uuid
      ..bookId = bookId
      ..pageIndex = pageIndex
      ..x = x
      ..y = y
      ..content = content
      ..color = color
      ..authorId = _currentUserId!
      ..authorName = _currentUserName ?? 'Unknown'
      ..createdAt = now
      ..isSynced = false
      ..isDeleted = false;

    await _isar.writeTxn(() async {
      await _isar.stickyNoteEntitys.put(entity);
    });

    final noteData = {
      'bookId': bookId,
      'pageIndex': pageIndex,
      'x': x,
      'y': y,
      'content': content,
      'color': color,
      'authorId': _currentUserId,
      'authorName': _currentUserName ?? 'Unknown',
      'createdAt': FieldValue.serverTimestamp(),
    };

    try {
      await _firestore
          .collection('users')
          .doc(ownerId)
          .collection('text_books')
          .doc(bookId)
          .collection('notes')
          .doc(uuid)
          .set(noteData);

      await _isar.writeTxn(() async {
        entity.isSynced = true;
        await _isar.stickyNoteEntitys.put(entity);
      });
    } catch (e) {
      await _syncQueue.addToQueue('SYNC_STICKY_NOTE', {
        'action': 'add',
        'ownerId': ownerId,
        'bookId': bookId,
        'noteId': uuid,
        ...noteData,
        // Override serverTimestamp for sync queue serialization if needed,
        // but sync worker handles it.
        // Actually, we should pass the raw values.
        'createdAt': now.toIso8601String(),
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
    final entity = await _isar.stickyNoteEntitys
        .filter()
        .firestoreIdEqualTo(noteId)
        .findFirst();

    if (entity == null) return;

    await _isar.writeTxn(() async {
      if (content != null) entity.content = content;
      if (x != null) entity.x = x;
      if (y != null) entity.y = y;
      if (color != null) entity.color = color;
      entity.isSynced = false;
      await _isar.stickyNoteEntitys.put(entity);
    });

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

      await _isar.writeTxn(() async {
        entity.isSynced = true;
        await _isar.stickyNoteEntitys.put(entity);
      });
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
    final entity = await _isar.stickyNoteEntitys
        .filter()
        .firestoreIdEqualTo(noteId)
        .findFirst();

    if (entity == null) return;

    await _isar.writeTxn(() async {
      entity.isDeleted = true;
      entity.isSynced = false;
      await _isar.stickyNoteEntitys.put(entity);
    });

    try {
      await _firestore
          .collection('users')
          .doc(ownerId)
          .collection('text_books')
          .doc(bookId)
          .collection('notes')
          .doc(noteId)
          .delete();

      await _isar.writeTxn(() async {
        await _isar.stickyNoteEntitys.delete(entity.id);
      });
    } catch (e) {
      await _syncQueue.addToQueue('SYNC_STICKY_NOTE', {
        'action': 'delete',
        'ownerId': ownerId,
        'bookId': bookId,
        'noteId': noteId,
      });
    }
  }

  Future<void> syncNoteOperation(Map<String, dynamic> payload) async {
    final action = payload['action'] as String;
    final ownerId = payload['ownerId'] as String;
    final bookId = payload['bookId'] as String;
    final noteId = payload['noteId'] as String;

    if (action == 'add') {
      await _firestore
          .collection('users')
          .doc(ownerId)
          .collection('text_books')
          .doc(bookId)
          .collection('notes')
          .doc(noteId)
          .set({
        'bookId': bookId,
        'pageIndex': payload['pageIndex'],
        'x': payload['x'],
        'y': payload['y'],
        'content': payload['content'],
        'color': payload['color'],
        'authorId': payload['authorId'],
        'authorName': payload['authorName'],
        'createdAt': payload['createdAt'] is String
            ? DateTime.parse(payload['createdAt'])
            : FieldValue.serverTimestamp(),
      });
    } else if (action == 'update') {
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
  final localDb = ref.watch(localDatabaseProvider);

  return StickyNoteRepository(
    FirebaseFirestore.instance,
    localDb.isar,
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
