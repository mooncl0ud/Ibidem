import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../reader/bookmark_repository.dart';
import '../reader/highlight_repository.dart';
import '../library/text_book_repository.dart';
import 'sync_manager.dart';

import '../reader/sticky_note_repository.dart';

part 'sync_worker.g.dart';

class SyncWorker {
  final SyncQueueService _queueService;
  final BookmarkRepository _bookmarkRepository;
  final HighlightRepository _highlightRepository;
  final TextBookRepository _textBookRepository;
  final StickyNoteRepository _stickyNoteRepository;

  SyncWorker(
    this._queueService,
    this._bookmarkRepository,
    this._highlightRepository,
    this._textBookRepository,
    this._stickyNoteRepository,
  );

  Future<void> processQueue() async {
    final items = await _queueService.getPendingItems();

    for (final item in items) {
      bool success = false;
      try {
        final payload = jsonDecode(item.payload) as Map<String, dynamic>;

        // For sticky notes, bookId might be in the payload but we don't always need it parsed as int
        // because StickyNoteRepository handles it as String.
        // However, for other repositories, we might need it as int.
        // We'll parse it if present, but be careful using it.

        switch (item.action) {
          case 'SYNC_BOOKMARKS':
            final bookId = _parseBookId(payload['bookId']);
            await _bookmarkRepository.syncBookmarks(bookId);
            success = true;
            break;
          case 'DELETE_BOOKMARK':
            final bookId = _parseBookId(payload['bookId']);
            final charPosition = payload['charPosition'] as int;
            await _bookmarkRepository.deleteBookmarkFromFirestore(
              bookId,
              charPosition,
            );
            success = true;
            break;
          case 'SYNC_HIGHLIGHTS':
            final bookId = _parseBookId(payload['bookId']);
            await _highlightRepository.syncHighlights(bookId);
            success = true;
            break;
          case 'SYNC_POSITION':
            final bookId = _parseBookId(payload['bookId']);
            await _textBookRepository.syncPositionToFirestore(bookId);
            success = true;
            break;
          case 'SYNC_STICKY_NOTE':
            await _stickyNoteRepository.syncNoteOperation(payload);
            success = true;
            break;
        }
      } catch (e) {
        debugPrint('Sync worker failed for item ${item.id}: $e');
        if (item.retryCount > 5) {
          await _queueService.deleteItem(item.id);
        } else {
          await _queueService.incrementRetry(item.id);
        }
      }

      if (success) {
        await _queueService.deleteItem(item.id);
      }
    }
  }

  int _parseBookId(dynamic id) {
    if (id is int) return id;
    if (id is String) return int.tryParse(id) ?? 0;
    return 0;
  }
}

@Riverpod(keepAlive: true)
SyncWorker syncWorker(SyncWorkerRef ref) {
  return SyncWorker(
    ref.watch(syncQueueServiceProvider),
    ref.watch(bookmarkRepositoryProvider),
    ref.watch(highlightRepositoryProvider),
    ref.watch(textBookRepositoryProvider),
    ref.watch(stickyNoteRepositoryProvider),
  );
}
