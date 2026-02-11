import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/core/usecases/usecase.dart';
import 'package:ramadan_habit_tracker/features/habits/domain/entities/habit.dart';
import 'package:ramadan_habit_tracker/features/habits/domain/repositories/habit_repository.dart';

class GetHabits extends UseCase<List<Habit>, NoParams> {
  final HabitRepository repository;

  GetHabits(this.repository);

  @override
  Future<Either<Failure, List<Habit>>> call(NoParams params) {
    return repository.getHabits();
  }
}
