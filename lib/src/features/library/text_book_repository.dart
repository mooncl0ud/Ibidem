import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:file_picker/file_picker.dart';
import '../../data/local/local_database_provider.dart';
import '../../data/local/schema/text_book_schema.dart';
import '../authentication/auth_repository.dart';
import '../reader/text_parser.dart';

part 'text_book_repository.g.dart';

class TextBookRepository {
  final Isar _isar;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final String? _userId;
  final TextParser _textParser = TextParser();

  TextBookRepository(this._isar, this._firestore, this._storage, this._userId);

  Future<List<TextBook>> getBooks() async {
    return _isar.textBooks.where().findAll();
  }

  Stream<List<TextBook>> watchBooks() {
    return _isar.textBooks.where().watch(fireImmediately: true);
  }

  Future<TextBook?> importTextFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );

    if (result == null || result.files.isEmpty) {
      return null;
    }

    final file = File(result.files.single.path!);
    final fileName = result.files.single.name;
    final title = fileName.replaceAll('.txt', '');

    // Detect encoding
    final encodingName = await _textParser.detectEncodingName(file);

    // Generate Chunk Offsets & Count Characters (Streamed)
    final (totalChars, byteOffsets, charOffsets) =
        await _textParser.analyzeFile(file, encodingName: encodingName);

    // Upload to Firebase Storage if user is logged in
    String? storageUrl;
    if (_userId != null) {
      try {
        storageUrl = await _uploadToStorage(file, fileName);
      } catch (e) {
        debugPrint('Failed to upload to storage: $e');
        // Continue without upload
      }
    }

    final book = TextBook()
      ..title = title
      ..author = 'Unknown'
      ..filePath = file.path
      ..coverUrl = storageUrl
      ..encoding = encodingName
      ..totalCharacters = totalChars
      ..currentCharPosition = 0
      ..currentPage = 0
      ..totalPages = 0
      ..addedAt = DateTime.now()
      ..lastReadAt = DateTime.now()
      ..fileSizeBytes = await file.length()
      ..chunkOffsets = byteOffsets
      ..chunkCharOffsets = charOffsets;

    await _isar.writeTxn(() async {
      await _isar.textBooks.put(book);
    });

    // Sync to Firestore
    if (_userId != null) {
      try {
        await _syncBookToFirestore(book, storageUrl);
      } catch (e) {
        debugPrint('Failed to sync to Firestore: $e');
        // Continue without sync
      }
    }

    return book;
  }

  Future<void> deleteBook(TextBook book) async {
    // 1. Delete from Isar
    await _isar.writeTxn(() async {
      await _isar.textBooks.delete(book.id);
    });

    if (_userId == null) return;

    try {
      // 2. Delete from Firestore
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('text_books')
          .doc(book.id.toString())
          .delete();

      // 3. Delete from Storage (if it was uploaded by me)
      // Only delete if I am the owner (sourceId is null)
      if (book.sourceId == null) {
        final fileName =
            '${book.title}.txt'; // Assumption based on import logic
        final ref = _storage.ref().child('books/$_userId/$fileName');
        await ref.delete();
      }
    } catch (e) {
      debugPrint('Failed to delete remote book resources: $e');
      // We don't re-throw here because local deletion is the priority for the user
    }
  }

  Future<String> _uploadToStorage(File file, String fileName) async {
    final ref = _storage.ref().child('books/$_userId/$fileName');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<TextBook> importSharedBook(
    File file,
    String title,
    String sourceId,
    String ownerId,
  ) async {
    // Check if we already have this shared book
    final existingBook = await _isar.textBooks
        .filter()
        .sourceIdEqualTo(sourceId)
        .and()
        .ownerIdEqualTo(ownerId)
        .findFirst();

    if (existingBook != null) {
      // Update file path if changed (e.g. re-downloaded)
      if (existingBook.filePath != file.path) {
        existingBook.filePath = file.path;
        await _isar.writeTxn(() async {
          await _isar.textBooks.put(existingBook);
        });
      }
      return existingBook;
    }

    // Create new book entry
    final fileSize = await file.length();
    final encodingName = await _textParser.detectEncodingName(file);

    // For shared books, we also need to analyze chunks
    final (totalChars, byteOffsets, charOffsets) =
        await _textParser.analyzeFile(file, encodingName: encodingName);

    final book = TextBook()
      ..title = title
      ..author = 'Shared by friend'
      ..filePath = file.path
      ..fileSizeBytes = fileSize
      ..encoding = encodingName
      ..totalCharacters = totalChars
      ..currentCharPosition = 0
      ..currentPage = 0
      ..totalPages = 0
      ..addedAt = DateTime.now()
      ..lastReadAt = DateTime.now()
      ..sourceId = sourceId
      ..ownerId = ownerId
      ..chunkOffsets = byteOffsets
      ..chunkCharOffsets = charOffsets;

    await _isar.writeTxn(() async {
      await _isar.textBooks.put(book);
    });

    // Sync initial state to Firestore (so we track it immediately)
    if (_userId != null) {
      try {
        await _syncBookToFirestore(book, null);
      } catch (e) {
        debugPrint('Failed to sync shared book to Firestore: $e');
      }
    }

    return book;
  }

  Future<void> _syncBookToFirestore(TextBook book, String? downloadUrl) async {
    if (_userId == null) return;

    final data = {
      'title': book.title,
      'author': book.author,
      'encoding': book.encoding,
      'totalCharacters': book.totalCharacters,
      'addedAt': Timestamp.fromDate(book.addedAt ?? DateTime.now()),
      'lastReadAt': Timestamp.fromDate(book.lastReadAt ?? DateTime.now()),
      'currentPosition': book.currentCharPosition,
    };

    if (downloadUrl != null) {
      data['filePath'] = downloadUrl;
    } else if (book.sourceId != null) {
      // For shared books, we assume the file is already available via the source
      // We store metadata to track progress
      data['sourceId'] = book.sourceId;
      data['ownerId'] = book.ownerId;
    } else {
      data['filePath'] = book.filePath;
    }

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('text_books')
        .doc(book.id.toString())
        .set(data, SetOptions(merge: true));
  }

  Future<void> updateProgress(
    int bookId,
    int charPosition,
    int page,
    int totalPages,
  ) async {
    final book = await _isar.textBooks.get(bookId);
    if (book != null) {
      book.currentCharPosition = charPosition;
      book.currentPage = page;
      book.totalPages = totalPages;
      book.lastReadAt = DateTime.now();

      await _isar.writeTxn(() async {
        await _isar.textBooks.put(book);
      });
      // NOTE: Real-time sync removed as per user request.
      // Sync will be triggered manually on exit/pause.
    }
  }

  Future<void> updateBookMetadata(TextBook book) async {
    await _isar.writeTxn(() async {
      await _isar.textBooks.put(book);
    });
  }

  Future<void> syncPositionToFirestore(int bookId) async {
    if (_userId == null) return;
    final book = await _isar.textBooks.get(bookId);
    if (book == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('text_books')
          .doc(book.id.toString())
          .set({
        'title': book.title,
        'author': book.author,
        'encoding': book.encoding,
        'totalCharacters': book.totalCharacters,
        'addedAt': book.addedAt != null
            ? Timestamp.fromDate(book.addedAt!)
            : FieldValue.serverTimestamp(),
        'lastReadAt': book.lastReadAt != null
            ? Timestamp.fromDate(book.lastReadAt!)
            : FieldValue.serverTimestamp(),
        'currentPosition': book.currentCharPosition,
        // We don't overwrite filePath here as it might be a download URL
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Failed to sync position to Firestore: $e');
    }
  }

  Future<void> syncPositionFromFirestore(int bookId) async {
    if (_userId == null) return;
    final book = await _isar.textBooks.get(bookId);
    if (book == null) return;

    try {
      final doc = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('text_books')
          .doc(book.id.toString())
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        final remotePosition = data['currentPosition'] as int?;
        final remoteLastRead = (data['lastReadAt'] as Timestamp?)?.toDate();

        // Conflict resolution: Use the most recent one
        if (remotePosition != null && remoteLastRead != null) {
          if (book.lastReadAt == null ||
              remoteLastRead.isAfter(book.lastReadAt!)) {
            book.currentCharPosition = remotePosition;
            book.lastReadAt = remoteLastRead;
            await _isar.writeTxn(() async {
              await _isar.textBooks.put(book);
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Failed to sync position from Firestore: $e');
    }
  }
}

@riverpod
TextBookRepository textBookRepository(TextBookRepositoryRef ref) {
  final localDb = ref.watch(localDatabaseProvider);
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  final user = ref.watch(authRepositoryProvider).currentUser;
  return TextBookRepository(localDb.isar, firestore, storage, user?.uid);
}

@riverpod
Stream<List<TextBook>> textBooks(TextBooksRef ref) {
  final repository = ref.watch(textBookRepositoryProvider);
  return repository.watchBooks();
}
