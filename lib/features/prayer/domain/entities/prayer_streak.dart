import 'package:equatable/equatable.dart';

class PrayerStreak extends Equatable {
  final int currentStreak;
  final int longestStreak;
  final List<bool> weeklyCompletion; // 7 days, Mon-Sun

  const PrayerStreak({
    required this.currentStreak,
    required this.longestStreak,
    required this.weeklyCompletion,
  });

  @override
  List<Object?> get props => [currentStreak, longestStreak, weeklyCompletion];
}
