part of 'habit_bloc.dart';

sealed class HabitState extends Equatable {
  const HabitState();

  @override
  List<Object> get props => [];
}

class HabitInitial extends HabitState {
  const HabitInitial();
}

class HabitLoading extends HabitState {
  const HabitLoading();
}

class HabitLoaded extends HabitState {
  final List<Habit> habits;
  final List<HabitLog> todayLogs;

  const HabitLoaded({required this.habits, required this.todayLogs});

  @override
  List<Object> get props => [habits, todayLogs];
}

class HabitError extends HabitState {
  final String message;

  const HabitError(this.message);

  @override
  List<Object> get props => [message];
}
