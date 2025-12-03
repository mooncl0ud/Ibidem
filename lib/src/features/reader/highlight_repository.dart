import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../data/local/local_database_provider.dart';
import '../../data/local/schema/highlight_schema.dart';
import '../../data/local/schema/text_book_schema.dart';
import '../authentication/auth_repository.dart';

part 'highlight_repository.g.dart';

@Riverpod(keepAlive: true)
HighlightRepository highlightRepository(HighlightRepositoryRef ref) {
  final localDb = ref.watch(localDatabaseProvider);
  final user = ref.watch(authRepositoryProvider).currentUser;
  return HighlightRepository(
    localDb.isar,
    FirebaseFirestore.instance,
    user?.uid,
  );
}

@riverpod
Stream<List<Highlight>> highlightsStream(HighlightsStreamRef ref, int bookId) {
  return ref.watch(highlightRepositoryProvider).watchHighlights(bookId);
}

class HighlightRepository {
  final Isar _isar;
  final FirebaseFirestore _firestore;
  final String? _userId;

  HighlightRepository(this._isar, this._firestore, this._userId);

  Future<void> addHighlight({
    required int bookId,
    required int startPosition,
    required int endPosition,
    required String highlightedText,
    required String color,
    String? note,
  }) async {
    final uuid = const Uuid().v4();
    final now = DateTime.now();

    final highlight = Highlight()
      ..firestoreId = uuid
      ..bookId = bookId
      ..startPosition = startPosition
      ..endPosition = endPosition
      ..highlightedText = highlightedText
      ..color = color
      ..note = note
      ..createdAt = now
      ..isSynced = false
      ..isDeleted = false;

    await _isar.writeTxn(() async {
      await _isar.highlights.put(highlight);
    });

    // Auto-sync to Firestore
    await syncHighlights(bookId);
  }

  Future<void> removeHighlight(int id) async {
    final highlight = await _isar.highlights.get(id);
    if (highlight == null) return;

    final bookId = highlight.bookId;

    await _isar.writeTxn(() async {
      highlight.isDeleted = true;
      highlight.isSynced = false;
      await _isar.highlights.put(highlight);
    });

    // Auto-sync to Firestore
    await syncHighlights(bookId);
  }

  Future<List<Highlight>> getHighlights(int bookId) async {
    return _isar.highlights
        .filter()
        .bookIdEqualTo(bookId)
        .and()
        .isDeletedEqualTo(false)
        .sortByStartPosition()
        .findAll();
  }

  Stream<List<Highlight>> watchHighlights(int bookId) {
    return _isar.highlights
        .filter()
        .bookIdEqualTo(bookId)
        .and()
        .isDeletedEqualTo(false)
        .sortByStartPosition()
        .watch(fireImmediately: true);
  }

  // --- Synchronization Methods ---

  Future<void> syncHighlights(int bookId) async {
    if (_userId == null) return;

    // Check if book is shared (skip Firestore sync for shared books)
    final book = await _isar.textBooks.get(bookId);
    if (book != null && book.ownerId != null && book.ownerId != _userId) {
      return; // Skip sync for shared books
    }

    try {
      // 1. Fetch remote highlights
      final snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('text_books')
          .doc(bookId.toString())
          .collection('highlights')
          .get();

      final remoteHighlights = snapshot.docs;

      // 2. Fetch local highlights (including deleted ones for sync)
      final localHighlights =
          await _isar.highlights.filter().bookIdEqualTo(bookId).findAll();

      // 3. Sync Down (Remote -> Local)
      await _isar.writeTxn(() async {
        for (final doc in remoteHighlights) {
          final data = doc.data();
          final firestoreId = doc.id;

          // Check if exists locally
          final existing = localHighlights.firstWhere(
            (h) => h.firestoreId == firestoreId,
            orElse: () => Highlight()..firestoreId = firestoreId,
          );

          // If local is modified and not synced, skip overwriting (conflict resolution: local wins or keep local)
          // For now, let's say server wins if local is synced, or if it's a new item.
          // But if local has pending changes (isSynced=false), we might want to push local up.
          // Simple strategy: Server wins unless local has unsynced changes.
          if (!existing.isSynced && existing.id != Isar.autoIncrement) {
            continue;
          }

          existing.bookId = bookId;
          existing.startPosition = data['startPosition'] as int;
          existing.endPosition = data['endPosition'] as int;
          existing.highlightedText = data['highlightedText'] as String;
          existing.color = data['color'] as String;
          existing.note = data['note'] as String?;
          existing.createdAt = (data['createdAt'] as Timestamp).toDate();
          existing.isSynced = true;
          existing.isDeleted = false; // If it's on server, it's not deleted

          await _isar.highlights.put(existing);
        }

        // Handle deletions from server (if not in remote but in local and synced, delete local)
        // This is tricky without a "deleted" collection on server or soft deletes on server.
        // If server hard deletes, we need to know.
        // Current assumption: If we have it locally as synced, and it's missing from server, it means it was deleted on another device.
        for (final local in localHighlights) {
          if (local.isSynced && !local.isDeleted) {
            final existsRemote =
                remoteHighlights.any((doc) => doc.id == local.firestoreId);
            if (!existsRemote) {
              // Deleted on server
              await _isar.highlights.delete(local.id);
            }
          }
        }
      });

      // 4. Sync Up (Local -> Remote)
      for (final local in localHighlights) {
        if (local.isSynced) continue;

        if (local.isDeleted) {
          // Delete from server
          await _firestore
              .collection('users')
              .doc(_userId)
              .collection('text_books')
              .doc(bookId.toString())
              .collection('highlights')
              .doc(local.firestoreId)
              .delete();

          // Hard delete locally after sync
          await _isar.writeTxn(() async {
            await _isar.highlights.delete(local.id);
          });
        } else {
          // Add/Update server
          await _firestore
              .collection('users')
              .doc(_userId)
              .collection('text_books')
              .doc(bookId.toString())
              .collection('highlights')
              .doc(local.firestoreId)
              .set({
            'startPosition': local.startPosition,
            'endPosition': local.endPosition,
            'highlightedText': local.highlightedText,
            'color': local.color,
            'note': local.note,
            'createdAt': Timestamp.fromDate(local.createdAt),
          });

          await _isar.writeTxn(() async {
            local.isSynced = true;
            await _isar.highlights.put(local);
          });
        }
      }
    } catch (e) {
      debugPrint('Failed to sync highlights: $e');
    }
  }
}
