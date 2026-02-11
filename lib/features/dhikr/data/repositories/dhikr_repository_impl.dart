import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/exceptions.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/features/dhikr/data/datasources/dhikr_local_datasource.dart';
import 'package:ramadan_habit_tracker/features/dhikr/data/models/dhikr_model.dart';
import 'package:ramadan_habit_tracker/features/dhikr/domain/entities/dhikr.dart';
import 'package:ramadan_habit_tracker/features/dhikr/domain/repositories/dhikr_repository.dart';

class DhikrRepositoryImpl implements DhikrRepository {
  final DhikrLocalDataSource localDataSource;

  DhikrRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Dhikr>>> getDhikrList() async {
    try {
      final models = await localDataSource.getDhikrList();
      return Right(models.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Dhikr>> incrementDhikr(String id) async {
    try {
      final model = await localDataSource.incrementDhikr(id);
      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Dhikr>> resetDhikr(String id) async {
    try {
      final model = await localDataSource.resetDhikr(id);
      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Dhikr>> addDhikr(Dhikr dhikr) async {
    try {
      final model = DhikrModel.fromEntity(dhikr);
      final result = await localDataSource.addDhikr(model);
      return Right(result.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
