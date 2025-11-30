import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'schema/book_schema.dart';
import 'schema/user_schema.dart';
import 'schema/text_book_schema.dart';
import 'schema/bookmark_schema.dart';
import 'schema/highlight_schema.dart';
import 'schema/reading_settings_schema.dart';
import 'schema/sync_queue_schema.dart';

class LocalDatabase {
  late Isar _isar;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open([
      BookSchema,
      UserSchema,
      TextBookSchema,
      BookmarkSchema,
      HighlightSchema,
      ReadingSettingsSchema,
      SyncQueueItemSchema,
    ], directory: dir.path);
  }

  Isar get isar => _isar;
}
