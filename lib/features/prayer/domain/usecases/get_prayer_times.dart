import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/core/usecases/usecase.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/entities/prayer_time.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/repositories/prayer_repository.dart';

class GetPrayerTimes extends UseCase<List<PrayerTime>, GetPrayerTimesParams> {
  final PrayerRepository repository;

  GetPrayerTimes(this.repository);

  @override
  Future<Either<Failure, List<PrayerTime>>> call(GetPrayerTimesParams params) {
    return repository.getPrayerTimes(
      city: params.city,
      country: params.country,
      method: params.method,
    );
  }
}

class GetPrayerTimesParams {
  final String city;
  final String country;
  final int method;

  const GetPrayerTimesParams({
    required this.city,
    required this.country,
    this.method = 2,
  });
}
