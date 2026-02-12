import 'package:equatable/equatable.dart';

class PrayerTime extends Equatable {
  final String name;
  final String time; // "HH:mm" format
  final bool isCompleted;
  final bool isNext;

  const PrayerTime({
    required this.name,
    required this.time,
    this.isCompleted = false,
    this.isNext = false,
  });

  PrayerTime copyWith({
    String? name,
    String? time,
    bool? isCompleted,
    bool? isNext,
  }) {
    return PrayerTime(
      name: name ?? this.name,
      time: time ?? this.time,
      isCompleted: isCompleted ?? this.isCompleted,
      isNext: isNext ?? this.isNext,
    );
  }

  @override
  List<Object?> get props => [name, time, isCompleted, isNext];
}
