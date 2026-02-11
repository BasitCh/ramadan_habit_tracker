import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/entities/prayer_log.dart';

abstract class PrayerRepository {
  Future<Either<Failure, PrayerLog>> getPrayerLog(DateTime date);
  Future<Either<Failure, PrayerLog>> togglePrayer(DateTime date, String prayerName);
}
