import 'package:isar/isar.dart';

part 'text_book_schema.g.dart';

@collection
class TextBook {
  Id id = Isar.autoIncrement;

  late String title;
  String? author;
  late String filePath; // Local path or Firebase Storage URL
  String? coverUrl;

  // Encoding information
  late String encoding; // UTF-8, EUC-KR, CP949, etc.

  // Reading progress
  late int totalCharacters;
  late int currentCharPosition;
  late int currentPage;
  late int totalPages;

  // Metadata
  // For shared books
  String? sourceId; // The original Firestore document ID
  String? ownerId; // The original owner's UID

  DateTime? addedAt;
  DateTime? lastReadAt;

  // File info
  late int fileSizeBytes;
  List<int>? chunkOffsets; // Byte offsets for chunked loading (e.g. every 50KB)
  List<int>?
      chunkCharOffsets; // Character offsets corresponding to chunkOffsets
}
