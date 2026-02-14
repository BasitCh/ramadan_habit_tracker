import 'package:ramadan_habit_tracker/features/prayer/domain/entities/hijri_date.dart';

class HijriDateModel extends HijriDate {
  const HijriDateModel({
    required super.day,
    required super.monthEn,
    required super.monthAr,
    required super.year,
    required super.weekdayEn,
    required super.weekdayAr,
  });

  factory HijriDateModel.fromApiJson(Map<String, dynamic> json) {
    final month = json['month'] as Map<String, dynamic>? ?? {};
    final weekday = json['weekday'] as Map<String, dynamic>? ?? {};

    return HijriDateModel(
      day: json['day']?.toString() ?? '',
      monthEn: month['en']?.toString() ?? '',
      monthAr: month['ar']?.toString() ?? '',
      year: json['year']?.toString() ?? '',
      weekdayEn: weekday['en']?.toString() ?? '',
      weekdayAr: weekday['ar']?.toString() ?? '',
    );
  }

  factory HijriDateModel.fromJson(Map<String, dynamic> json) {
    return HijriDateModel(
      day: json['day'] as String? ?? '',
      monthEn: json['monthEn'] as String? ?? '',
      monthAr: json['monthAr'] as String? ?? '',
      year: json['year'] as String? ?? '',
      weekdayEn: json['weekdayEn'] as String? ?? '',
      weekdayAr: json['weekdayAr'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'day': day,
        'monthEn': monthEn,
        'monthAr': monthAr,
        'year': year,
        'weekdayEn': weekdayEn,
        'weekdayAr': weekdayAr,
      };
}
