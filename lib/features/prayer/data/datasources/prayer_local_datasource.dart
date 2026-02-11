import 'package:hive/hive.dart';
import 'package:ramadan_habit_tracker/core/constants/app_constants.dart';
import 'package:ramadan_habit_tracker/core/error/exceptions.dart';
import 'package:ramadan_habit_tracker/core/extensions/date_extensions.dart';
import 'package:ramadan_habit_tracker/features/prayer/data/models/prayer_log_model.dart';

abstract class PrayerLocalDataSource {
  Future<PrayerLogModel> getPrayerLog(DateTime date);
  Future<PrayerLogModel> togglePrayer(DateTime date, String prayerName);
}

class PrayerLocalDataSourceImpl implements PrayerLocalDataSource {
  final Box<PrayerLogModel> prayerLogsBox;

  PrayerLocalDataSourceImpl({required this.prayerLogsBox});

  @override
  Future<PrayerLogModel> getPrayerLog(DateTime date) async {
    try {
      final key = date.dateKey;
      final existing = prayerLogsBox.get(key);
      if (existing != null) return existing;

      final allPrayers = [...AppConstants.prayerNames, ...AppConstants.additionalPrayers];
      final defaultLog = PrayerLogModel(
        date: DateTime(date.year, date.month, date.day),
        prayers: {for (final name in allPrayers) name: false},
      );
      await prayerLogsBox.put(key, defaultLog);
      return defaultLog;
    } catch (e) {
      throw const CacheException('Failed to get prayer log');
    }
  }

  @override
  Future<PrayerLogModel> togglePrayer(DateTime date, String prayerName) async {
    try {
      final key = date.dateKey;
      final log = await getPrayerLog(date);
      final updatedPrayers = Map<String, bool>.from(log.prayers);
      updatedPrayers[prayerName] = !(updatedPrayers[prayerName] ?? false);

      final updated = PrayerLogModel(
        date: log.date,
        prayers: updatedPrayers,
      );
      await prayerLogsBox.put(key, updated);
      return updated;
    } catch (e) {
      throw const CacheException('Failed to toggle prayer');
    }
  }
}
