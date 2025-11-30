import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/local/local_database_provider.dart';
import '../../data/local/schema/highlight_schema.dart';
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
    final highlight = Highlight()
      ..bookId = bookId
      ..startPosition = startPosition
      ..endPosition = endPosition
      ..highlightedText = highlightedText
      ..color = color
      ..note = note
      ..createdAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.highlights.put(highlight);
    });
  }

  Future<void> removeHighlight(int id) async {
    await _isar.writeTxn(() async {
      await _isar.highlights.delete(id);
    });
  }

  Future<List<Highlight>> getHighlights(int bookId) async {
    return _isar.highlights
        .filter()
        .bookIdEqualTo(bookId)
        .sortByStartPosition()
        .findAll();
  }

  Stream<List<Highlight>> watchHighlights(int bookId) {
    return _isar.highlights
        .filter()
        .bookIdEqualTo(bookId)
        .sortByStartPosition()
        .watch(fireImmediately: true);
  }

  // --- Synchronization Methods ---

  Future<void> syncHighlights(int bookId) async {
    if (_userId == null) return;

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

      // 2. Fetch local highlights
      final localHighlights = await getHighlights(bookId);

      // 3. Sync Down (Remote -> Local)
      await _isar.writeTxn(() async {
        for (final doc in remoteHighlights) {
          final data = doc.data();
          final startPos = data['startPosition'] as int;
          final endPos = data['endPosition'] as int;
          final text = data['highlightedText'] as String;
          final color = data['color'] as String;
          final note = data['note'] as String?;
          final createdAt = (data['createdAt'] as Timestamp).toDate();

          // Check if exists locally (by startPosition)
          final exists = localHighlights.any(
            (h) => h.startPosition == startPos,
          );
          if (!exists) {
            final newHighlight = Highlight()
              ..bookId = bookId
              ..startPosition = startPos
              ..endPosition = endPos
              ..highlightedText = text
              ..color = color
              ..note = note
              ..createdAt = createdAt;
            await _isar.highlights.put(newHighlight);
          }
        }
      });

      // 4. Sync Up (Local -> Remote)
      for (final local in localHighlights) {
        // Check if exists remotely (by startPosition)
        final exists = remoteHighlights.any(
          (doc) => doc['startPosition'] == local.startPosition,
        );
        if (!exists) {
          await _firestore
              .collection('users')
              .doc(_userId)
              .collection('text_books')
              .doc(bookId.toString())
              .collection('highlights')
              .add({
                'startPosition': local.startPosition,
                'endPosition': local.endPosition,
                'highlightedText': local.highlightedText,
                'color': local.color,
                'note': local.note,
                'createdAt': Timestamp.fromDate(local.createdAt),
              });
        }
      }
    } catch (e) {
      debugPrint('Failed to sync highlights: $e');
    }
  }
}
