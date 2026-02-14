import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/features/hadith/data/datasources/hadith_local_data_source.dart';
import 'package:ramadan_habit_tracker/features/hadith/data/datasources/hadith_remote_data_source.dart';
import 'package:ramadan_habit_tracker/features/hadith/data/models/hadith_cache_model.dart';
import 'package:ramadan_habit_tracker/features/hadith/domain/entities/hadith.dart';
import 'package:ramadan_habit_tracker/features/hadith/domain/repositories/hadith_repository.dart';

class HadithRepositoryImpl implements HadithRepository {
  final HadithRemoteDataSource remoteDataSource;
  final HadithLocalDataSource localDataSource;

  HadithRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, Hadith>> getDailyHadith() async {
    try {
      final cached = await localDataSource.getCachedHadith();
      if (cached != null && _isSameDay(cached.fetchedAt, DateTime.now())) {
        return Right(cached.toEntity());
      }

      final remote = await remoteDataSource.fetchDailyHadith();
      await localDataSource.cacheHadith(
        HadithCacheModel.fromEntity(remote, DateTime.now()),
      );
      return Right(remote);
    } catch (e) {
      // Return fallback on ANY error
      try {
        final fallback = await localDataSource.getFallbackHadith();
        return Right(fallback.toEntity());
      } catch (fallbackError) {
        return Left(CacheFailure('Failed to load fallback: $fallbackError'));
      }
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
