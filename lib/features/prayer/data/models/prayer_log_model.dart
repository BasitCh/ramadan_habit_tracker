import 'package:hive/hive.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/entities/prayer_log.dart';

part 'prayer_log_model.g.dart';

@HiveType(typeId: 12)
class PrayerLogModel extends HiveObject {
  @HiveField(0)
  final String dateKey; // "yyyy-MM-dd"

  @HiveField(1)
  final Map<String, bool> completedPrayers;

  PrayerLogModel({
    required this.dateKey,
    required this.completedPrayers,
  });

  factory PrayerLogModel.fromEntity(PrayerLog entity) {
    return PrayerLogModel(
      dateKey: '${entity.date.year}-${entity.date.month.toString().padLeft(2, '0')}-${entity.date.day.toString().padLeft(2, '0')}',
      completedPrayers: Map<String, bool>.from(entity.completedPrayers),
    );
  }

  PrayerLog toEntity() {
    final parts = dateKey.split('-');
    return PrayerLog(
      date: DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2])),
      completedPrayers: Map<String, bool>.from(completedPrayers),
    );
  }

  factory PrayerLogModel.empty(String dateKey) {
    return PrayerLogModel(
      dateKey: dateKey,
      completedPrayers: {
        'Fajr': false,
        'Dhuhr': false,
        'Asr': false,
        'Maghrib': false,
        'Isha': false,
      },
    );
  }
}
