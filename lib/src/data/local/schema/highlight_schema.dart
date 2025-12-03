import 'package:isar/isar.dart';

part 'highlight_schema.g.dart';

@collection
class Highlight {
  Id id = Isar.autoIncrement;

  // Reference to book
  late int bookId;

  // Text selection
  late int startPosition;
  late int endPosition;
  late String highlightedText;

  // Highlight color (hex string)
  late String color; // e.g., "#FFF9C4", "#FFCCBC", "#B3E5FC"

  // Optional note
  String? note;

  // Metadata
  late DateTime createdAt;

  @Index()
  late String firestoreId;

  @Index()
  bool isSynced = true;

  @Index()
  bool isDeleted = false;
}
