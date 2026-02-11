import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/core/usecases/usecase.dart';
import 'package:ramadan_habit_tracker/features/habits/domain/entities/habit_log.dart';
import 'package:ramadan_habit_tracker/features/habits/domain/repositories/habit_repository.dart';

class GetHabitLogsForDate extends UseCase<List<HabitLog>, DateTime> {
  final HabitRepository repository;

  GetHabitLogsForDate(this.repository);

  @override
  Future<Either<Failure, List<HabitLog>>> call(DateTime params) {
    return repository.getHabitLogsForDate(params);
  }
}
