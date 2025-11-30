import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../authentication/auth_repository.dart';

part 'note_repository.g.dart';

class StickyNote {
  final String id;
  final String bookId;
  final String content;
  final String cfi; // Position in book
  final DateTime createdAt;
  final bool isShared;
  final String userId;

  StickyNote({
    required this.id,
    required this.bookId,
    required this.content,
    required this.cfi,
    required this.createdAt,
    required this.isShared,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookId': bookId,
      'content': content,
      'cfi': cfi,
      'createdAt': Timestamp.fromDate(createdAt),
      'isShared': isShared,
      'userId': userId,
    };
  }

  factory StickyNote.fromMap(Map<String, dynamic> map, String id) {
    return StickyNote(
      id: id,
      bookId: map['bookId'] as String,
      content: map['content'] as String,
      cfi: map['cfi'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      isShared: map['isShared'] as bool? ?? false,
      userId: map['userId'] as String,
    );
  }
}

class NoteRepository {
  final FirebaseFirestore _firestore;
  final String? _userId;

  NoteRepository(this._firestore, this._userId);

  Future<void> addNote(StickyNote note) async {
    if (_userId == null) return;

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('notes')
        .doc(note.id)
        .set(note.toMap());
  }

  Stream<List<StickyNote>> watchNotesForBook(String bookId) {
    if (_userId == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('notes')
        .where('bookId', isEqualTo: bookId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => StickyNote.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> deleteNote(String noteId) async {
    if (_userId == null) return;

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('notes')
        .doc(noteId)
        .delete();
  }

  Future<void> shareNote(String noteId) async {
    if (_userId == null) return;

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('notes')
        .doc(noteId)
        .update({'isShared': true});
  }
}

@Riverpod(keepAlive: true)
NoteRepository noteRepository(NoteRepositoryRef ref) {
  final user = ref.watch(authRepositoryProvider).currentUser;
  return NoteRepository(FirebaseFirestore.instance, user?.uid);
}

@riverpod
Stream<List<StickyNote>> notesForBook(NotesForBookRef ref, String bookId) {
  return ref.watch(noteRepositoryProvider).watchNotesForBook(bookId);
}
