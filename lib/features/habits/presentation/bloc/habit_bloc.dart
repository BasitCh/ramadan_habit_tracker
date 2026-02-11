import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ramadan_habit_tracker/core/usecases/usecase.dart';
import 'package:ramadan_habit_tracker/features/habits/domain/entities/habit.dart';
import 'package:ramadan_habit_tracker/features/habits/domain/entities/habit_log.dart';
import 'package:ramadan_habit_tracker/features/habits/domain/usecases/add_habit.dart';
import 'package:ramadan_habit_tracker/features/habits/domain/usecases/delete_habit.dart';
import 'package:ramadan_habit_tracker/features/habits/domain/usecases/get_habit_logs_for_date.dart';
import 'package:ramadan_habit_tracker/features/habits/domain/usecases/get_habits.dart';
import 'package:ramadan_habit_tracker/features/habits/domain/usecases/toggle_habit_log.dart';
import 'package:uuid/uuid.dart';

part 'habit_event.dart';
part 'habit_state.dart';

class HabitBloc extends Bloc<HabitEvent, HabitState> {
  final GetHabits getHabits;
  final AddHabit addHabit;
  final DeleteHabit deleteHabit;
  final ToggleHabitLog toggleHabitLog;
  final GetHabitLogsForDate getHabitLogsForDate;
  final Uuid uuid;

  HabitBloc({
    required this.getHabits,
    required this.addHabit,
    required this.deleteHabit,
    required this.toggleHabitLog,
    required this.getHabitLogsForDate,
    required this.uuid,
  }) : super(const HabitInitial()) {
    on<LoadHabits>(_onLoadHabits);
    on<AddHabitRequested>(_onAddHabit);
    on<DeleteHabitRequested>(_onDeleteHabit);
    on<ToggleHabitRequested>(_onToggleHabit);
  }

  Future<void> _onLoadHabits(LoadHabits event, Emitter<HabitState> emit) async {
    emit(const HabitLoading());
    final habitsResult = await getHabits(const NoParams());
    final logsResult = await getHabitLogsForDate(DateTime.now());

    habitsResult.fold(
      (failure) => emit(HabitError(failure.message)),
      (habits) {
        logsResult.fold(
          (failure) => emit(HabitError(failure.message)),
          (logs) => emit(HabitLoaded(habits: habits, todayLogs: logs)),
        );
      },
    );
  }

  Future<void> _onAddHabit(AddHabitRequested event, Emitter<HabitState> emit) async {
    final habit = Habit(
      id: uuid.v4(),
      name: event.name,
      description: event.description,
      createdAt: DateTime.now(),
    );
    final result = await addHabit(habit);
    result.fold(
      (failure) => emit(HabitError(failure.message)),
      (_) => add(const LoadHabits()),
    );
  }

  Future<void> _onDeleteHabit(DeleteHabitRequested event, Emitter<HabitState> emit) async {
    final result = await deleteHabit(event.habitId);
    result.fold(
      (failure) => emit(HabitError(failure.message)),
      (_) => add(const LoadHabits()),
    );
  }

  Future<void> _onToggleHabit(ToggleHabitRequested event, Emitter<HabitState> emit) async {
    final result = await toggleHabitLog(
      ToggleHabitLogParams(habitId: event.habitId, date: event.date),
    );
    result.fold(
      (failure) => emit(HabitError(failure.message)),
      (_) => add(const LoadHabits()),
    );
  }
}
