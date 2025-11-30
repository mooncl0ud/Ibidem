import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:file_picker/file_picker.dart';
import '../../data/local/local_database_provider.dart';
import '../../data/local/schema/book_schema.dart';
import '../authentication/auth_repository.dart';

part 'book_repository.g.dart';

class BookRepository {
  final Isar _isar;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final String? _userId;

  BookRepository(this._isar, this._firestore, this._storage, this._userId);

  Future<List<Book>> getBooks() async {
    return _isar.books.where().findAll();
  }

  Stream<List<Book>> watchBooks() {
    return _isar.books.where().watch(fireImmediately: true);
  }

  Future<Book?> addBook(Book book) async {
    await _isar.writeTxn(() async {
      await _isar.books.put(book);
    });

    // Sync to Firestore if user is logged in
    if (_userId != null) {
      await _syncBookToFirestore(book);
    }

    return book;
  }

  Future<Book?> importEpubFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['epub'],
    );

    if (result == null || result.files.isEmpty) {
      return null;
    }

    final file = File(result.files.single.path!);
    final fileName = result.files.single.name;

    // Upload to Firebase Storage if user is logged in
    String? downloadUrl;
    if (_userId != null) {
      downloadUrl = await _uploadToStorage(file, fileName);
    }

    // Create book entry
    final book = Book()
      ..title = fileName.replaceAll('.epub', '')
      ..author = 'Unknown'
      ..filePath = downloadUrl ?? file.path
      ..addedAt = DateTime.now()
      ..lastReadAt = DateTime.now()
      ..currentPosition = '0';

    return await addBook(book);
  }

  Future<String> _uploadToStorage(File file, String fileName) async {
    final ref = _storage.ref().child('books/$_userId/$fileName');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<void> _syncBookToFirestore(Book book) async {
    if (_userId == null) return;

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('books')
        .doc(book.id.toString())
        .set({
          'title': book.title,
          'author': book.author,
          'filePath': book.filePath,
          'coverUrl': book.coverUrl,
          'addedAt': Timestamp.fromDate(book.addedAt),
          'lastReadAt': Timestamp.fromDate(book.lastReadAt),
          'currentPosition': book.currentPosition,
        });
  }

  Future<void> syncFromFirestore() async {
    if (_userId == null) return;

    final snapshot = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('books')
        .get();

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final book = Book()
        ..title = data['title'] as String
        ..author = data['author'] as String? ?? 'Unknown'
        ..filePath = data['filePath'] as String
        ..coverUrl = data['coverUrl'] as String?
        ..addedAt = (data['addedAt'] as Timestamp).toDate()
        ..lastReadAt = (data['lastReadAt'] as Timestamp).toDate()
        ..currentPosition = data['currentPosition'] as String;

      await _isar.writeTxn(() async {
        await _isar.books.put(book);
      });
    }
  }
}

@Riverpod(keepAlive: true)
BookRepository bookRepository(BookRepositoryRef ref) {
  final localDb = ref.watch(localDatabaseProvider);
  final user = ref.watch(authRepositoryProvider).currentUser;
  return BookRepository(
    localDb.isar,
    FirebaseFirestore.instance,
    FirebaseStorage.instance,
    user?.uid,
  );
}

@riverpod
Stream<List<Book>> books(BooksRef ref) {
  return ref.watch(bookRepositoryProvider).watchBooks();
}
