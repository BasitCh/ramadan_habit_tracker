import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/exceptions.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/features/quran/data/datasources/quran_local_datasource.dart';
import 'package:ramadan_habit_tracker/features/quran/data/models/quran_progress_model.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/entities/quran_progress.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/repositories/quran_repository.dart';

class QuranRepositoryImpl implements QuranRepository {
  final QuranLocalDataSource localDataSource;

  QuranRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, QuranProgress>> getQuranProgress(DateTime date) async {
    try {
      final model = await localDataSource.getQuranProgress(date);
      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, QuranProgress>> updateQuranProgress(
    QuranProgress progress,
  ) async {
    try {
      final model = QuranProgressModel.fromEntity(progress);
      final result = await localDataSource.updateQuranProgress(model);
      return Right(result.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
