import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/entities/prayer_log.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/entities/prayer_streak.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/entities/prayer_times_result.dart';

abstract class PrayerRepository {
  /// Fetch prayer times from API for a location
  Future<Either<Failure, PrayerTimesResult>> getPrayerTimes({
    required double lat,
    required double lng,
    required DateTime date,
    required int method,
  });

  /// Get cached prayer times
  Future<Either<Failure, PrayerTimesResult>> getCachedPrayerTimes();

  /// Get prayer log for a specific date
  Future<Either<Failure, PrayerLog>> getPrayerLog(DateTime date);

  /// Toggle prayer completion
  Future<Either<Failure, PrayerLog>> togglePrayerCompletion(
    DateTime date,
    String prayerName,
  );

  /// Get prayer streak data
  Future<Either<Failure, PrayerStreak>> getPrayerStreak();
}
