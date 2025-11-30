import 'package:isar/isar.dart';

part 'bookmark_schema.g.dart';

@collection
class Bookmark {
  Id id = Isar.autoIncrement;

  // Reference to book
  late int bookId;

  // Position information
  late int charPosition;
  late int pageNumber;

  // User-defined label
  String? label;

  // Metadata
  late DateTime createdAt;
}
