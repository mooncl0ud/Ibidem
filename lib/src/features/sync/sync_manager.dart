import 'dart:convert';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/local/local_database_provider.dart';
import '../../data/local/schema/sync_queue_schema.dart';

part 'sync_manager.g.dart';

class SyncQueueService {
  final Isar _isar;

  SyncQueueService(this._isar);

  Future<void> addToQueue(String action, Map<String, dynamic> payload) async {
    final item = SyncQueueItem()
      ..action = action
      ..payload = jsonEncode(payload)
      ..createdAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.syncQueueItems.put(item);
    });
  }

  Future<List<SyncQueueItem>> getPendingItems() async {
    return _isar.syncQueueItems.where().sortByCreatedAt().findAll();
  }

  Future<void> deleteItem(Id id) async {
    await _isar.writeTxn(() async {
      await _isar.syncQueueItems.delete(id);
    });
  }

  Future<void> incrementRetry(Id id) async {
    final item = await _isar.syncQueueItems.get(id);
    if (item != null) {
      item.retryCount++;
      await _isar.writeTxn(() async {
        await _isar.syncQueueItems.put(item);
      });
    }
  }
}

@Riverpod(keepAlive: true)
SyncQueueService syncQueueService(SyncQueueServiceRef ref) {
  final localDb = ref.watch(localDatabaseProvider);
  return SyncQueueService(localDb.isar);
}
