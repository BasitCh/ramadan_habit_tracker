import 'package:hive/hive.dart';
import 'package:ramadan_habit_tracker/core/error/exceptions.dart';
import 'package:ramadan_habit_tracker/features/prayer/data/models/prayer_log_model.dart';
import 'package:ramadan_habit_tracker/features/prayer/data/models/prayer_time_model.dart';

abstract class PrayerTimesLocalDataSource {
  Future<void> cachePrayerTimes(List<PrayerTimeModel> times);
  Future<List<PrayerTimeModel>> getCachedPrayerTimes();
  Future<PrayerLogModel> getPrayerLog(String dateKey);
  Future<PrayerLogModel> togglePrayer(String dateKey, String prayerName);
  Future<Map<String, PrayerLogModel>> getAllPrayerLogs();
}

class PrayerTimesLocalDataSourceImpl implements PrayerTimesLocalDataSource {
  final Box<PrayerTimeModel> prayerTimesBox;
  final Box<PrayerLogModel> prayerLogsBox;

  PrayerTimesLocalDataSourceImpl({
    required this.prayerTimesBox,
    required this.prayerLogsBox,
  });

  @override
  Future<void> cachePrayerTimes(List<PrayerTimeModel> times) async {
    try {
      await prayerTimesBox.clear();
      for (final time in times) {
        await prayerTimesBox.put(time.name, time);
      }
    } catch (e) {
      throw CacheException('Failed to cache prayer times: $e');
    }
  }

  @override
  Future<List<PrayerTimeModel>> getCachedPrayerTimes() async {
    try {
      return prayerTimesBox.values.toList();
    } catch (e) {
      throw CacheException('Failed to get cached prayer times: $e');
    }
  }

  @override
  Future<PrayerLogModel> getPrayerLog(String dateKey) async {
    try {
      final existing = prayerLogsBox.get(dateKey);
      if (existing != null) return existing;

      final newLog = PrayerLogModel.empty(dateKey);
      await prayerLogsBox.put(dateKey, newLog);
      return newLog;
    } catch (e) {
      throw CacheException('Failed to get prayer log: $e');
    }
  }

  @override
  Future<PrayerLogModel> togglePrayer(String dateKey, String prayerName) async {
    try {
      var log = prayerLogsBox.get(dateKey) ?? PrayerLogModel.empty(dateKey);

      final updatedPrayers = Map<String, bool>.from(log.completedPrayers);
      updatedPrayers[prayerName] = !(updatedPrayers[prayerName] ?? false);

      final updatedLog = PrayerLogModel(
        dateKey: dateKey,
        completedPrayers: updatedPrayers,
      );

      await prayerLogsBox.put(dateKey, updatedLog);
      return updatedLog;
    } catch (e) {
      throw CacheException('Failed to toggle prayer: $e');
    }
  }

  @override
  Future<Map<String, PrayerLogModel>> getAllPrayerLogs() async {
    try {
      return Map.fromEntries(
        prayerLogsBox.keys.map((key) => MapEntry(key as String, prayerLogsBox.get(key)!)),
      );
    } catch (e) {
      throw CacheException('Failed to get all prayer logs: $e');
    }
  }
}
