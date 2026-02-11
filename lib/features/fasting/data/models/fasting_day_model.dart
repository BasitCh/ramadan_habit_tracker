import 'package:hive/hive.dart';
import 'package:ramadan_habit_tracker/features/fasting/domain/entities/fasting_day.dart';

part 'fasting_day_model.g.dart';

@HiveType(typeId: 4)
class FastingDayModel extends HiveObject {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final bool completed;

  @HiveField(2)
  final String? notes;

  FastingDayModel({
    required this.date,
    required this.completed,
    this.notes,
  });

  factory FastingDayModel.fromEntity(FastingDay day) {
    return FastingDayModel(
      date: day.date,
      completed: day.completed,
      notes: day.notes,
    );
  }

  FastingDay toEntity() {
    return FastingDay(
      date: date,
      completed: completed,
      notes: notes,
    );
  }
}
