part of 'habit_bloc.dart';

sealed class HabitEvent extends Equatable {
  const HabitEvent();

  @override
  List<Object?> get props => [];
}

class LoadHabits extends HabitEvent {
  const LoadHabits();
}

class AddHabitRequested extends HabitEvent {
  final String name;
  final String? description;

  const AddHabitRequested({required this.name, this.description});

  @override
  List<Object?> get props => [name, description];
}

class DeleteHabitRequested extends HabitEvent {
  final String habitId;

  const DeleteHabitRequested(this.habitId);

  @override
  List<Object?> get props => [habitId];
}

class ToggleHabitRequested extends HabitEvent {
  final String habitId;
  final DateTime date;

  const ToggleHabitRequested({required this.habitId, required this.date});

  @override
  List<Object?> get props => [habitId, date];
}
