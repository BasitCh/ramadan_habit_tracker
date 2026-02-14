import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/exceptions.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/features/prayer/data/datasources/prayer_times_local_datasource.dart';
import 'package:ramadan_habit_tracker/features/prayer/data/datasources/prayer_times_remote_datasource.dart';
import 'package:ramadan_habit_tracker/features/prayer/data/models/hijri_date_model.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/entities/prayer_log.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/entities/prayer_streak.dart';

import 'package:ramadan_habit_tracker/features/prayer/domain/entities/prayer_times_result.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/repositories/prayer_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ramadan_habit_tracker/core/constants/app_constants.dart';

class PrayerRepositoryImpl implements PrayerRepository {
  final PrayerTimesRemoteDataSource remoteDataSource;
  final PrayerTimesLocalDataSource localDataSource;
  final SharedPreferences sharedPreferences;

  PrayerRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.sharedPreferences,
  });

  String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  @override
  Future<Either<Failure, PrayerTimesResult>> getPrayerTimes({
    required double lat,
    required double lng,
    required DateTime date,
    required int method,
  }) async {
    try {
      final result = await remoteDataSource.fetchPrayerTimes(
        lat: lat,
        lng: lng,
        date: date,
        method: method,
      );

      // Cache the times
      await localDataSource.cachePrayerTimes(result.prayerTimes);

      // Get today's log to merge completion status
      final dateKey = _dateKey(date);
      final log = await localDataSource.getPrayerLog(dateKey);
      final nextPrayer = _calculateNextPrayer(result.prayerTimes);

      final times = result.prayerTimes.map((m) {
        return m.toEntity(
          isCompleted: log.completedPrayers[m.name] ?? false,
          isNext: m.name == nextPrayer,
        );
      }).toList();

      await _cacheHijriDate(result.hijriDate);

      return Right(
        PrayerTimesResult(prayerTimes: times, hijriDate: result.hijriDate),
      );
    } on NetworkException catch (e) {
      // Try cached data on network error
      return _getCachedWithStatus(e.message);
    } on ServerException catch (e) {
      return _getCachedWithStatus(e.message);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, PrayerTimesResult>> _getCachedWithStatus(
    String errorMsg,
  ) async {
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

      return Right(
        PrayerTimesResult(prayerTimes: times, hijriDate: _getCachedHijriDate()),
      );
    } catch (_) {
      return Left(NetworkFailure(errorMsg));
    }
  }

  @override
  Future<Either<Failure, PrayerTimesResult>> getCachedPrayerTimes() async {
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

      return Right(
        PrayerTimesResult(prayerTimes: times, hijriDate: _getCachedHijriDate()),
      );
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
      final model = await localDataSource.togglePrayer(
        _dateKey(date),
        prayerName,
      );
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

        if (log != null &&
            log.completedPrayers.values.where((v) => v).length == 5) {
          tempStreak++;
          if (i == currentStreak) currentStreak++;
        } else {
          if (i > 0) break;
        }
      }

      // Find longest streak and total completed
      tempStreak = 0;
      int totalCompleted = 0;
      for (final log in allLogs.values) {
        final completedCount = log.completedPrayers.values
            .where((v) => v)
            .length;
        totalCompleted += completedCount;

        if (completedCount == 5) {
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
        return log != null &&
            log.completedPrayers.values.where((v) => v).length == 5;
      });

      return Right(
        PrayerStreak(
          currentStreak: currentStreak,
          longestStreak: longestStreak,
          totalPrayersCompleted: totalCompleted,
          weeklyCompletion: weeklyCompletion,
        ),
      );
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

  Future<void> _cacheHijriDate(HijriDateModel? hijriDate) async {
    if (hijriDate == null) return;
    await sharedPreferences.setString(
      AppConstants.lastHijriDateKey,
      jsonEncode(hijriDate.toJson()),
    );
  }

  HijriDateModel? _getCachedHijriDate() {
    final raw = sharedPreferences.getString(AppConstants.lastHijriDateKey);
    if (raw == null || raw.isEmpty) return null;

    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return HijriDateModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }
}
