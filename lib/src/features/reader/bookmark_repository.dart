import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/local/local_database_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/local/schema/bookmark_schema.dart';
import '../authentication/auth_repository.dart';
import '../sync/sync_manager.dart';

part 'bookmark_repository.g.dart';

@Riverpod(keepAlive: true)
BookmarkRepository bookmarkRepository(BookmarkRepositoryRef ref) {
  final localDb = ref.watch(localDatabaseProvider);
  final user = ref.watch(authRepositoryProvider).currentUser;
  final syncQueue = ref.watch(syncQueueServiceProvider);
  return BookmarkRepository(
    localDb.isar,
    FirebaseFirestore.instance,
    user?.uid,
    syncQueue,
  );
}

@riverpod
Stream<List<Bookmark>> bookmarksStream(BookmarksStreamRef ref, int bookId) {
  return ref.watch(bookmarkRepositoryProvider).watchBookmarks(bookId);
}

class BookmarkRepository {
  final Isar _isar;
  final FirebaseFirestore _firestore;
  final String? _userId;
  final SyncQueueService _syncQueue;

  BookmarkRepository(
    this._isar,
    this._firestore,
    this._userId,
    this._syncQueue,
  );

  Future<void> addBookmark({
    required int bookId,
    required int charPosition,
    required int pageNumber,
    String? label,
  }) async {
    final bookmark = Bookmark()
      ..bookId = bookId
      ..charPosition = charPosition
      ..pageNumber = pageNumber
      ..label = label
      ..createdAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.bookmarks.put(bookmark);
    });

    try {
      await syncBookmarks(bookId);
    } catch (e) {
      await _syncQueue.addToQueue('SYNC_BOOKMARKS', {
        'bookId': bookId.toString(),
      });
    }
  }

  Future<void> removeBookmark(int id) async {
    final bookmark = await _isar.bookmarks.get(id);
    if (bookmark == null) return;

    final bookId = bookmark.bookId;
    final charPosition = bookmark.charPosition;

    await _isar.writeTxn(() async {
      await _isar.bookmarks.delete(id);
    });

    try {
      await deleteBookmarkFromFirestore(bookId, charPosition);
    } catch (e) {
      await _syncQueue.addToQueue('DELETE_BOOKMARK', {
        'bookId': bookId.toString(),
        'charPosition': charPosition,
      });
    }
  }

  Future<void> removeBookmarkByPosition(int bookId, int pageNumber) async {
    final bookmarks = await _isar.bookmarks
        .filter()
        .bookIdEqualTo(bookId)
        .and()
        .pageNumberEqualTo(pageNumber)
        .findAll();

    if (bookmarks.isEmpty) return;

    // Assuming one bookmark per page for simplicity, or delete all
    for (final b in bookmarks) {
      await removeBookmark(b.id);
    }
  }

  Future<List<Bookmark>> getBookmarks(int bookId) async {
    return _isar.bookmarks
        .filter()
        .bookIdEqualTo(bookId)
        .sortByCreatedAtDesc()
        .findAll();
  }

  Stream<List<Bookmark>> watchBookmarks(int bookId) {
    return _isar.bookmarks
        .filter()
        .bookIdEqualTo(bookId)
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true);
  }

  Future<bool> isBookmarked(int bookId, int pageNumber) async {
    final count = await _isar.bookmarks
        .filter()
        .bookIdEqualTo(bookId)
        .and()
        .pageNumberEqualTo(pageNumber)
        .count();
    return count > 0;
  }

  // --- Synchronization Methods ---

  Future<void> deleteBookmarkFromFirestore(int bookId, int charPosition) async {
    if (_userId == null) return;

    final snapshot = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('text_books')
        .doc(bookId.toString())
        .collection('bookmarks')
        .where('charPosition', isEqualTo: charPosition)
        .get();

    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> syncBookmarks(dynamic bookId) async {
    if (_userId == null) return;
    final bookIdStr = bookId.toString();
    final bookIdInt = int.tryParse(bookIdStr) ?? 0;

    try {
      // 1. Fetch remote bookmarks
      final snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('text_books')
          .doc(bookIdStr)
          .collection('bookmarks')
          .get();

      final remoteBookmarks = snapshot.docs;

      // 2. Fetch local bookmarks
      final localBookmarks = await getBookmarks(bookIdInt);

      // 3. Merge Strategy (Union)

      // Sync Down (Remote -> Local)
      await _isar.writeTxn(() async {
        for (final doc in remoteBookmarks) {
          final data = doc.data();
          final charPos = data['charPosition'] as int;
          final pageNum = data['pageNumber'] as int;
          final label = data['label'] as String?;
          final createdAt = (data['createdAt'] as Timestamp).toDate();

          // Check if exists locally
          final exists = localBookmarks.any((b) => b.charPosition == charPos);
          if (!exists) {
            final newBookmark = Bookmark()
              ..bookId = bookIdInt
              ..charPosition = charPos
              ..pageNumber = pageNum
              ..label = label
              ..createdAt = createdAt;
            await _isar.bookmarks.put(newBookmark);
          }
        }
      });

      // Sync Up (Local -> Remote)
      for (final local in localBookmarks) {
        // Check if exists remotely (by charPosition)
        final exists = remoteBookmarks.any(
          (doc) => doc['charPosition'] == local.charPosition,
        );
        if (!exists) {
          await _firestore
              .collection('users')
              .doc(_userId)
              .collection('text_books')
              .doc(bookIdStr)
              .collection('bookmarks')
              .add({
                'charPosition': local.charPosition,
                'pageNumber': local.pageNumber,
                'label': local.label,
                'createdAt': Timestamp.fromDate(local.createdAt),
              });
        }
      }
    } catch (e) {
      debugPrint('Failed to sync bookmarks: $e');
      rethrow; // Re-throw to trigger queueing
    }
  }
}
