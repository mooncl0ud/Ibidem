import 'package:isar/isar.dart';

part 'sticky_note_schema.g.dart';

@collection
class StickyNoteEntity {
  Id id = Isar.autoIncrement;

  @Index()
  late String firestoreId;

  @Index()
  late String bookId;

  late String content;
  late String color;
  late int pageIndex;
  late double x;
  late double y;
  late String authorId;
  late String authorName;
  late DateTime createdAt;

  @Index()
  bool isSynced = true;

  @Index()
  bool isDeleted = false;
}
