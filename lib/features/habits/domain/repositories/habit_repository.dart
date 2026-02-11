import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/features/habits/domain/entities/habit.dart';
import 'package:ramadan_habit_tracker/features/habits/domain/entities/habit_log.dart';

abstract class HabitRepository {
  Future<Either<Failure, List<Habit>>> getHabits();
  Future<Either<Failure, Habit>> addHabit(Habit habit);
  Future<Either<Failure, void>> deleteHabit(String habitId);
  Future<Either<Failure, HabitLog>> toggleHabitLog(String habitId, DateTime date);
  Future<Either<Failure, List<HabitLog>>> getHabitLogsForDate(DateTime date);
}
