import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/exceptions.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/features/prayer/data/datasources/prayer_local_datasource.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/entities/prayer_log.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/repositories/prayer_repository.dart';

class PrayerRepositoryImpl implements PrayerRepository {
  final PrayerLocalDataSource localDataSource;

  PrayerRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, PrayerLog>> getPrayerLog(DateTime date) async {
    try {
      final model = await localDataSource.getPrayerLog(date);
      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, PrayerLog>> togglePrayer(
    DateTime date,
    String prayerName,
  ) async {
    try {
      final model = await localDataSource.togglePrayer(date, prayerName);
      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
