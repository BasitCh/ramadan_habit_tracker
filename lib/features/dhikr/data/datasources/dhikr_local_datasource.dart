import 'package:hive/hive.dart';
import 'package:ramadan_habit_tracker/core/error/exceptions.dart';
import 'package:ramadan_habit_tracker/features/dhikr/data/models/dhikr_model.dart';

abstract class DhikrLocalDataSource {
  Future<List<DhikrModel>> getDhikrList();
  Future<DhikrModel> incrementDhikr(String id);
  Future<DhikrModel> resetDhikr(String id);
  Future<DhikrModel> addDhikr(DhikrModel dhikr);
}

class DhikrLocalDataSourceImpl implements DhikrLocalDataSource {
  final Box<DhikrModel> dhikrBox;

  DhikrLocalDataSourceImpl({required this.dhikrBox});

  @override
  Future<List<DhikrModel>> getDhikrList() async {
    try {
      return dhikrBox.values.toList();
    } catch (e) {
      throw const CacheException('Failed to get dhikr list');
    }
  }

  @override
  Future<DhikrModel> incrementDhikr(String id) async {
    try {
      final existing = dhikrBox.get(id);
      if (existing == null) throw const CacheException('Dhikr not found');

      final updated = DhikrModel(
        id: existing.id,
        name: existing.name,
        targetCount: existing.targetCount,
        currentCount: existing.currentCount + 1,
      );
      await dhikrBox.put(id, updated);
      return updated;
    } catch (e) {
      throw CacheException('Failed to increment dhikr: $e');
    }
  }

  @override
  Future<DhikrModel> resetDhikr(String id) async {
    try {
      final existing = dhikrBox.get(id);
      if (existing == null) throw const CacheException('Dhikr not found');

      final updated = DhikrModel(
        id: existing.id,
        name: existing.name,
        targetCount: existing.targetCount,
        currentCount: 0,
      );
      await dhikrBox.put(id, updated);
      return updated;
    } catch (e) {
      throw CacheException('Failed to reset dhikr: $e');
    }
  }

  @override
  Future<DhikrModel> addDhikr(DhikrModel dhikr) async {
    try {
      await dhikrBox.put(dhikr.id, dhikr);
      return dhikr;
    } catch (e) {
      throw const CacheException('Failed to add dhikr');
    }
  }
}
