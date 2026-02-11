import 'package:hive/hive.dart';
import 'package:ramadan_habit_tracker/core/error/exceptions.dart';
import 'package:ramadan_habit_tracker/core/extensions/date_extensions.dart';
import 'package:ramadan_habit_tracker/features/fasting/data/models/fasting_day_model.dart';

abstract class FastingLocalDataSource {
  Future<List<FastingDayModel>> getFastingLogs();
  Future<FastingDayModel> toggleFasting(DateTime date);
}

class FastingLocalDataSourceImpl implements FastingLocalDataSource {
  final Box<FastingDayModel> fastingLogsBox;

  FastingLocalDataSourceImpl({required this.fastingLogsBox});

  @override
  Future<List<FastingDayModel>> getFastingLogs() async {
    try {
      return fastingLogsBox.values.toList()
        ..sort((a, b) => a.date.compareTo(b.date));
    } catch (e) {
      throw const CacheException('Failed to get fasting logs');
    }
  }

  @override
  Future<FastingDayModel> toggleFasting(DateTime date) async {
    try {
      final key = date.dateKey;
      final existing = fastingLogsBox.get(key);

      if (existing != null) {
        final toggled = FastingDayModel(
          date: existing.date,
          completed: !existing.completed,
          notes: existing.notes,
        );
        await fastingLogsBox.put(key, toggled);
        return toggled;
      } else {
        final newDay = FastingDayModel(
          date: DateTime(date.year, date.month, date.day),
          completed: true,
        );
        await fastingLogsBox.put(key, newDay);
        return newDay;
      }
    } catch (e) {
      throw const CacheException('Failed to toggle fasting');
    }
  }
}
