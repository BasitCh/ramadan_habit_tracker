import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/exceptions.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/features/adhkar/data/datasources/adhkar_local_datasource.dart';
import 'package:ramadan_habit_tracker/features/adhkar/domain/entities/adhkar.dart';
import 'package:ramadan_habit_tracker/features/adhkar/domain/repositories/adhkar_repository.dart';

class AdhkarRepositoryImpl implements AdhkarRepository {
  final AdhkarLocalDataSource localDataSource;

  AdhkarRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Adhkar>>> getAdhkarByCategory(String category) async {
    try {
      final models = await localDataSource.getByCategory(category);
      return Right(models.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Adhkar>> incrementAdhkar(String adhkarId) async {
    try {
      final model = await localDataSource.incrementCount(adhkarId);
      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> resetDailyProgress() async {
    try {
      await localDataSource.resetDailyProgress();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
