import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/core/usecases/usecase.dart';
import 'package:ramadan_habit_tracker/features/habits/domain/entities/habit.dart';
import 'package:ramadan_habit_tracker/features/habits/domain/repositories/habit_repository.dart';

class AddHabit extends UseCase<Habit, Habit> {
  final HabitRepository repository;

  AddHabit(this.repository);

  @override
  Future<Either<Failure, Habit>> call(Habit params) {
    return repository.addHabit(params);
  }
}
