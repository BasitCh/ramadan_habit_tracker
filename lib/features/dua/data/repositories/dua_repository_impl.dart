import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/exceptions.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/features/dua/data/datasources/dua_local_datasource.dart';
import 'package:ramadan_habit_tracker/features/dua/domain/entities/dua.dart';
import 'package:ramadan_habit_tracker/features/dua/domain/repositories/dua_repository.dart';

class DuaRepositoryImpl implements DuaRepository {
  final DuaLocalDataSource localDataSource;

  DuaRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, Dua>> getDailyDua() async {
    try {
      final model = await localDataSource.getDailyDua();
      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> toggleBookmark(String duaId) async {
    try {
      await localDataSource.toggleBookmark(duaId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRecited(String duaId) async {
    try {
      await localDataSource.markAsRecited(duaId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Dua>>> getBookmarkedDuas() async {
    try {
      final models = await localDataSource.getBookmarkedDuas();
      return Right(models.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
