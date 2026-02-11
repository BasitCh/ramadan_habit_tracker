import 'package:hive/hive.dart';
import 'package:ramadan_habit_tracker/core/error/exceptions.dart';
import 'package:ramadan_habit_tracker/core/extensions/date_extensions.dart';
import 'package:ramadan_habit_tracker/features/habits/data/models/habit_log_model.dart';
import 'package:ramadan_habit_tracker/features/habits/data/models/habit_model.dart';
import 'package:uuid/uuid.dart';

abstract class HabitLocalDataSource {
  Future<List<HabitModel>> getHabits();
  Future<HabitModel> addHabit(HabitModel habit);
  Future<void> deleteHabit(String habitId);
  Future<HabitLogModel> toggleHabitLog(String habitId, DateTime date);
  Future<List<HabitLogModel>> getHabitLogsForDate(DateTime date);
}

class HabitLocalDataSourceImpl implements HabitLocalDataSource {
  final Box<HabitModel> habitsBox;
  final Box<HabitLogModel> habitLogsBox;
  final Uuid uuid;

  HabitLocalDataSourceImpl({
    required this.habitsBox,
    required this.habitLogsBox,
    required this.uuid,
  });

  @override
  Future<List<HabitModel>> getHabits() async {
    try {
      return habitsBox.values.toList();
    } catch (e) {
      throw const CacheException('Failed to get habits');
    }
  }

  @override
  Future<HabitModel> addHabit(HabitModel habit) async {
    try {
      await habitsBox.put(habit.id, habit);
      return habit;
    } catch (e) {
      throw const CacheException('Failed to add habit');
    }
  }

  @override
  Future<void> deleteHabit(String habitId) async {
    try {
      await habitsBox.delete(habitId);
      // Also delete associated logs
      final logsToDelete = habitLogsBox.values
          .where((log) => log.habitId == habitId)
          .map((log) => log.key as dynamic)
          .toList();
      await habitsBox.deleteAll([habitId]);
      await habitLogsBox.deleteAll(logsToDelete);
    } catch (e) {
      throw const CacheException('Failed to delete habit');
    }
  }

  @override
  Future<HabitLogModel> toggleHabitLog(String habitId, DateTime date) async {
    try {
      final dateKey = date.dateKey;
      final logKey = '${habitId}_$dateKey';

      final existing = habitLogsBox.get(logKey);
      if (existing != null) {
        final toggled = HabitLogModel(
          id: existing.id,
          habitId: existing.habitId,
          date: existing.date,
          completed: !existing.completed,
        );
        await habitLogsBox.put(logKey, toggled);
        return toggled;
      } else {
        final newLog = HabitLogModel(
          id: uuid.v4(),
          habitId: habitId,
          date: DateTime(date.year, date.month, date.day),
          completed: true,
        );
        await habitLogsBox.put(logKey, newLog);
        return newLog;
      }
    } catch (e) {
      throw const CacheException('Failed to toggle habit log');
    }
  }

  @override
  Future<List<HabitLogModel>> getHabitLogsForDate(DateTime date) async {
    try {
      final dateKey = date.dateKey;
      return habitLogsBox.values
          .where((log) => log.date.dateKey == dateKey)
          .toList();
    } catch (e) {
      throw const CacheException('Failed to get habit logs');
    }
  }
}
