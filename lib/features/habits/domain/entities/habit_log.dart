import 'package:equatable/equatable.dart';

class HabitLog extends Equatable {
  final String id;
  final String habitId;
  final DateTime date;
  final bool completed;

  const HabitLog({
    required this.id,
    required this.habitId,
    required this.date,
    required this.completed,
  });

  HabitLog copyWith({bool? completed}) {
    return HabitLog(
      id: id,
      habitId: habitId,
      date: date,
      completed: completed ?? this.completed,
    );
  }

  @override
  List<Object> get props => [id, habitId, date, completed];
}
