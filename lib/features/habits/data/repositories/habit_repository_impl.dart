import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/exceptions.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/features/habits/data/datasources/habit_local_datasource.dart';
import 'package:ramadan_habit_tracker/features/habits/data/models/habit_model.dart';
import 'package:ramadan_habit_tracker/features/habits/domain/entities/habit.dart';
import 'package:ramadan_habit_tracker/features/habits/domain/entities/habit_log.dart';
import 'package:ramadan_habit_tracker/features/habits/domain/repositories/habit_repository.dart';

class HabitRepositoryImpl implements HabitRepository {
  final HabitLocalDataSource localDataSource;

  HabitRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Habit>>> getHabits() async {
    try {
      final models = await localDataSource.getHabits();
      return Right(models.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Habit>> addHabit(Habit habit) async {
    try {
      final model = HabitModel.fromEntity(habit);
      final result = await localDataSource.addHabit(model);
      return Right(result.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteHabit(String habitId) async {
    try {
      await localDataSource.deleteHabit(habitId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, HabitLog>> toggleHabitLog(
    String habitId,
    DateTime date,
  ) async {
    try {
      final result = await localDataSource.toggleHabitLog(habitId, date);
      return Right(result.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<HabitLog>>> getHabitLogsForDate(
    DateTime date,
  ) async {
    try {
      final models = await localDataSource.getHabitLogsForDate(date);
      return Right(models.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
