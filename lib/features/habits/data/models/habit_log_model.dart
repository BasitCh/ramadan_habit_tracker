import 'package:hive/hive.dart';
import 'package:ramadan_habit_tracker/features/habits/domain/entities/habit_log.dart';

part 'habit_log_model.g.dart';

@HiveType(typeId: 1)
class HabitLogModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String habitId;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final bool completed;

  HabitLogModel({
    required this.id,
    required this.habitId,
    required this.date,
    required this.completed,
  });

  factory HabitLogModel.fromEntity(HabitLog log) {
    return HabitLogModel(
      id: log.id,
      habitId: log.habitId,
      date: log.date,
      completed: log.completed,
    );
  }

  HabitLog toEntity() {
    return HabitLog(
      id: id,
      habitId: habitId,
      date: date,
      completed: completed,
    );
  }
}
