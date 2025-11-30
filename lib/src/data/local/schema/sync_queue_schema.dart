import 'package:isar/isar.dart';

part 'sync_queue_schema.g.dart';

@collection
class SyncQueueItem {
  Id id = Isar.autoIncrement;

  late String action; // e.g., 'ADD_BOOKMARK', 'DELETE_HIGHLIGHT'
  late String payload; // JSON string of the data
  late DateTime createdAt;
  int retryCount = 0;
}
