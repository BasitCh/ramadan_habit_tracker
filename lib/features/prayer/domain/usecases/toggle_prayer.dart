import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/core/usecases/usecase.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/entities/prayer_log.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/repositories/prayer_repository.dart';

class TogglePrayer extends UseCase<PrayerLog, TogglePrayerParams> {
  final PrayerRepository repository;

  TogglePrayer(this.repository);

  @override
  Future<Either<Failure, PrayerLog>> call(TogglePrayerParams params) {
    return repository.togglePrayer(params.date, params.prayerName);
  }
}

class TogglePrayerParams extends Equatable {
  final DateTime date;
  final String prayerName;

  const TogglePrayerParams({required this.date, required this.prayerName});

  @override
  List<Object> get props => [date, prayerName];
}
