import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/core/usecases/usecase.dart';
import 'package:ramadan_habit_tracker/features/habits/domain/entities/habit_log.dart';
import 'package:ramadan_habit_tracker/features/habits/domain/repositories/habit_repository.dart';

class ToggleHabitLog extends UseCase<HabitLog, ToggleHabitLogParams> {
  final HabitRepository repository;

  ToggleHabitLog(this.repository);

  @override
  Future<Either<Failure, HabitLog>> call(ToggleHabitLogParams params) {
    return repository.toggleHabitLog(params.habitId, params.date);
  }
}

class ToggleHabitLogParams extends Equatable {
  final String habitId;
  final DateTime date;

  const ToggleHabitLogParams({required this.habitId, required this.date});

  @override
  List<Object> get props => [habitId, date];
}
