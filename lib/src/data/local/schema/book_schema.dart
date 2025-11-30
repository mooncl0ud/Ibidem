import 'package:isar/isar.dart';

part 'book_schema.g.dart';

@collection
class Book {
  Id id = Isar.autoIncrement;

  late String title;
  String? author;
  late String filePath; // Can be local path or Firebase Storage URL
  String? coverUrl;

  late DateTime addedAt;
  late DateTime lastReadAt;
  late String currentPosition; // CFI or page number
}
