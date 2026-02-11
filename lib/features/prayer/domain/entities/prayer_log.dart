import 'package:equatable/equatable.dart';

class PrayerLog extends Equatable {
  final DateTime date;
  final Map<String, bool> prayers;

  const PrayerLog({
    required this.date,
    required this.prayers,
  });

  PrayerLog copyWith({Map<String, bool>? prayers}) {
    return PrayerLog(
      date: date,
      prayers: prayers ?? this.prayers,
    );
  }

  int get completedCount => prayers.values.where((v) => v).length;
  int get totalCount => prayers.length;

  @override
  List<Object> get props => [date, prayers];
}
