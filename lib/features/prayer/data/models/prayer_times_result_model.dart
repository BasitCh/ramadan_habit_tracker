import 'package:ramadan_habit_tracker/features/prayer/data/models/hijri_date_model.dart';
import 'package:ramadan_habit_tracker/features/prayer/data/models/prayer_time_model.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/entities/prayer_times_result.dart';

class PrayerTimesResultModel {
  final List<PrayerTimeModel> prayerTimes;
  final HijriDateModel? hijriDate;

  PrayerTimesResultModel({
    required this.prayerTimes,
    required this.hijriDate,
  });

  PrayerTimesResult toEntity() => PrayerTimesResult(
        prayerTimes: prayerTimes.map((m) => m.toEntity()).toList(),
        hijriDate: hijriDate,
      );
}
