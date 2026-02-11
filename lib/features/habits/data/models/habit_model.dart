import 'package:hive/hive.dart';
import 'package:ramadan_habit_tracker/features/habits/domain/entities/habit.dart';

part 'habit_model.g.dart';

@HiveType(typeId: 0)
class HabitModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final DateTime createdAt;

  HabitModel({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
  });

  factory HabitModel.fromEntity(Habit habit) {
    return HabitModel(
      id: habit.id,
      name: habit.name,
      description: habit.description,
      createdAt: habit.createdAt,
    );
  }

  Habit toEntity() {
    return Habit(
      id: id,
      name: name,
      description: description,
      createdAt: createdAt,
    );
  }
}
