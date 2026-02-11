import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/exceptions.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/features/fasting/data/datasources/fasting_local_datasource.dart';
import 'package:ramadan_habit_tracker/features/fasting/domain/entities/fasting_day.dart';
import 'package:ramadan_habit_tracker/features/fasting/domain/repositories/fasting_repository.dart';

class FastingRepositoryImpl implements FastingRepository {
  final FastingLocalDataSource localDataSource;

  FastingRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<FastingDay>>> getFastingLogs() async {
    try {
      final models = await localDataSource.getFastingLogs();
      return Right(models.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, FastingDay>> toggleFasting(DateTime date) async {
    try {
      final model = await localDataSource.toggleFasting(date);
      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
