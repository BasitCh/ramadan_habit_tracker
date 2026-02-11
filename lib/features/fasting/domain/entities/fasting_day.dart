import 'package:equatable/equatable.dart';

class FastingDay extends Equatable {
  final DateTime date;
  final bool completed;
  final String? notes;

  const FastingDay({
    required this.date,
    required this.completed,
    this.notes,
  });

  FastingDay copyWith({bool? completed, String? notes}) {
    return FastingDay(
      date: date,
      completed: completed ?? this.completed,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [date, completed, notes];
}
