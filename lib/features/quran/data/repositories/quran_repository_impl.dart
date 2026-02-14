import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/exceptions.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/features/quran/data/datasources/quran_local_datasource.dart';
import 'package:ramadan_habit_tracker/features/quran/data/datasources/quran_text_local_datasource.dart';
import 'package:ramadan_habit_tracker/features/quran/data/datasources/quran_text_remote_datasource.dart';
import 'package:ramadan_habit_tracker/features/quran/data/models/surah_detail_cache_model.dart';
import 'package:ramadan_habit_tracker/features/quran/data/models/surah_list_cache_model.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/entities/quran_progress.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/entities/surah.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/entities/surah_detail.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/repositories/quran_repository.dart';

class QuranRepositoryImpl implements QuranRepository {
  final QuranLocalDataSource localDataSource;
  final QuranTextRemoteDataSource textRemoteDataSource;
  final QuranTextLocalDataSource textLocalDataSource;

  QuranRepositoryImpl({
    required this.localDataSource,
    required this.textRemoteDataSource,
    required this.textLocalDataSource,
  });

  @override
  Future<Either<Failure, QuranProgress>> getProgress() async {
    try {
      final model = await localDataSource.getProgress();
      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, QuranProgress>> updatePagesRead(int pages) async {
    try {
      final model = await localDataSource.updatePagesRead(pages);
      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, QuranProgress>> resetProgress() async {
    try {
      final model = await localDataSource.resetProgress();
      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Surah>>> getSurahList() async {
    try {
      final cached = await textLocalDataSource.getCachedSurahList();
      if (cached != null && _withinDays(cached.fetchedAt, 7)) {
        return Right(cached.toEntities());
      }

      final remote = await textRemoteDataSource.fetchSurahList();
      await textLocalDataSource.cacheSurahList(
        SurahListCacheModel.fromEntities(remote, DateTime.now()),
      );
      return Right(remote);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SurahDetail>> getSurahDetail(int surahNumber) async {
    try {
      final cached = await textLocalDataSource.getCachedSurahDetail(
        surahNumber,
      );
      if (cached != null && _withinDays(cached.fetchedAt, 30)) {
        return Right(cached.toEntity());
      }

      final remote = await textRemoteDataSource.fetchSurahDetail(surahNumber);
      await textLocalDataSource.cacheSurahDetail(
        SurahDetailCacheModel.fromEntity(remote, DateTime.now()),
      );
      return Right(remote);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  bool _withinDays(DateTime date, int days) {
    final now = DateTime.now();
    return now.difference(date).inDays <= days;
  }
}
