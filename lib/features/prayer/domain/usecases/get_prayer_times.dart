import 'package:dartz/dartz.dart';
import 'package:ramadan_habit_tracker/core/error/failures.dart';
import 'package:ramadan_habit_tracker/core/usecases/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/entities/prayer_times_result.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/repositories/prayer_repository.dart';

class GetPrayerTimes extends UseCase<PrayerTimesResult, GetPrayerTimesParams> {
  final PrayerRepository repository;

  GetPrayerTimes(this.repository);

  @override
  Future<Either<Failure, PrayerTimesResult>> call(GetPrayerTimesParams params) {
    return repository.getPrayerTimes(
      lat: params.lat,
      lng: params.lng,
      date: params.date,
      method: params.method,
    );
  }
}

class GetPrayerTimesParams extends Equatable {
  final double lat;
  final double lng;
  final DateTime date;
  final int method;

  const GetPrayerTimesParams({
    required this.lat,
    required this.lng,
    required this.date,
    this.method = 2,
  });

  @override
  List<Object> get props => [lat, lng, date, method];
}
