import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/core/usecases/usecase.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/entities/prayer_log.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/repositories/prayer_repository.dart';

class TogglePrayerCompletion extends UseCase<PrayerLog, TogglePrayerParams> {
  final PrayerRepository repository;

  TogglePrayerCompletion(this.repository);

  @override
  Future<Either<Failure, PrayerLog>> call(TogglePrayerParams params) {
    return repository.togglePrayerCompletion(params.date, params.prayerName);
  }
}

class TogglePrayerParams {
  final DateTime date;
  final String prayerName;

  const TogglePrayerParams({required this.date, required this.prayerName});
}
