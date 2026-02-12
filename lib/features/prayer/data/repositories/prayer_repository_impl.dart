import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/exceptions.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/features/prayer/data/datasources/prayer_times_local_datasource.dart';
import 'package:ramadan_habit_tracker/features/prayer/data/datasources/prayer_times_remote_datasource.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/entities/prayer_log.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/entities/prayer_streak.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/entities/prayer_time.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/repositories/prayer_repository.dart';

class PrayerRepositoryImpl implements PrayerRepository {
  final PrayerTimesRemoteDataSource remoteDataSource;
  final PrayerTimesLocalDataSource localDataSource;

  PrayerRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  @override
  Future<Either<Failure, List<PrayerTime>>> getPrayerTimes({
    required String city,
    required String country,
    required int method,
  }) async {
    try {
      final models = await remoteDataSource.fetchPrayerTimes(
        city: city,
        country: country,
        method: method,
      );

      // Cache the times
      await localDataSource.cachePrayerTimes(models);

      // Get today's log to merge completion status
      final dateKey = _dateKey(DateTime.now());
      final log = await localDataSource.getPrayerLog(dateKey);
      final nextPrayer = _calculateNextPrayer(models);

      final times = models.map((m) {
        return m.toEntity(
          isCompleted: log.completedPrayers[m.name] ?? false,
          isNext: m.name == nextPrayer,
        );
      }).toList();

      return Right(times);
    } on NetworkException catch (e) {
      // Try cached data on network error
      return _getCachedWithStatus(e.message);
    } on ServerException catch (e) {
      return _getCachedWithStatus(e.message);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<PrayerTime>>> _getCachedWithStatus(String errorMsg) async {
    try {
      final cached = await localDataSource.getCachedPrayerTimes();
      if (cached.isEmpty) {
        return Left(NetworkFailure(errorMsg));
      }

      final dateKey = _dateKey(DateTime.now());
      final log = await localDataSource.getPrayerLog(dateKey);
      final nextPrayer = _calculateNextPrayer(cached);

      final times = cached.map((m) {
        return m.toEntity(
          isCompleted: log.completedPrayers[m.name] ?? false,
          isNext: m.name == nextPrayer,
        );
      }).toList();

      return Right(times);
    } catch (_) {
      return Left(NetworkFailure(errorMsg));
    }
  }

  @override
  Future<Either<Failure, List<PrayerTime>>> getCachedPrayerTimes() async {
    try {
      final cached = await localDataSource.getCachedPrayerTimes();
      final dateKey = _dateKey(DateTime.now());
      final log = await localDataSource.getPrayerLog(dateKey);
      final nextPrayer = _calculateNextPrayer(cached);

      final times = cached.map((m) {
        return m.toEntity(
          isCompleted: log.completedPrayers[m.name] ?? false,
          isNext: m.name == nextPrayer,
        );
      }).toList();

      return Right(times);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, PrayerLog>> getPrayerLog(DateTime date) async {
    try {
      final model = await localDataSource.getPrayerLog(_dateKey(date));
      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, PrayerLog>> togglePrayerCompletion(
    DateTime date,
    String prayerName,
  ) async {
    try {
      final model = await localDataSource.togglePrayer(_dateKey(date), prayerName);
      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, PrayerStreak>> getPrayerStreak() async {
    try {
      final allLogs = await localDataSource.getAllPrayerLogs();

      int currentStreak = 0;
      int longestStreak = 0;
      int tempStreak = 0;

      // Calculate streak from today backwards
      final today = DateTime.now();
      for (int i = 0; i < 365; i++) {
        final date = today.subtract(Duration(days: i));
        final key = _dateKey(date);
        final log = allLogs[key];

        if (log != null && log.completedPrayers.values.where((v) => v).length == 5) {
          tempStreak++;
          if (i == currentStreak) currentStreak++;
        } else {
          if (i > 0) break;
        }
      }

      // Find longest streak
      tempStreak = 0;
      for (final log in allLogs.values) {
        if (log.completedPrayers.values.where((v) => v).length == 5) {
          tempStreak++;
          if (tempStreak > longestStreak) longestStreak = tempStreak;
        } else {
          tempStreak = 0;
        }
      }

      if (currentStreak > longestStreak) longestStreak = currentStreak;

      // Weekly completion (last 7 days)
      final weeklyCompletion = List.generate(7, (i) {
        final date = today.subtract(Duration(days: 6 - i));
        final key = _dateKey(date);
        final log = allLogs[key];
        return log != null && log.completedPrayers.values.where((v) => v).length == 5;
      });

      return Right(PrayerStreak(
        currentStreak: currentStreak,
        longestStreak: longestStreak,
        weeklyCompletion: weeklyCompletion,
      ));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  String? _calculateNextPrayer(List<dynamic> times) {
    final now = DateTime.now();
    final currentMinutes = now.hour * 60 + now.minute;

    for (final t in times) {
      final String timeStr = t is String ? t : (t as dynamic).time as String;
      final parts = timeStr.split(':');
      if (parts.length == 2) {
        final prayerMinutes = int.parse(parts[0]) * 60 + int.parse(parts[1]);
        if (prayerMinutes > currentMinutes) {
          final String name = t is String ? '' : (t as dynamic).name as String;
          return name;
        }
      }
    }
    return null;
  }
}
