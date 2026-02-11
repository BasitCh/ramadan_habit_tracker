import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/core/usecases/usecase.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/entities/prayer_log.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/repositories/prayer_repository.dart';

class GetPrayerLog extends UseCase<PrayerLog, DateTime> {
  final PrayerRepository repository;

  GetPrayerLog(this.repository);

  @override
  Future<Either<Failure, PrayerLog>> call(DateTime params) {
    return repository.getPrayerLog(params);
  }
}
