import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/entities/prayer_log.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/entities/prayer_streak.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/entities/prayer_time.dart';

abstract class PrayerRepository {
  /// Fetch prayer times from API for a city
  Future<Either<Failure, List<PrayerTime>>> getPrayerTimes({
    required String city,
    required String country,
    required int method,
  });

  /// Get cached prayer times
  Future<Either<Failure, List<PrayerTime>>> getCachedPrayerTimes();

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
