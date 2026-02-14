import 'package:equatable/equatable.dart';

class PrayerStreak extends Equatable {
  final int currentStreak;
  final int longestStreak;
  final int totalPrayersCompleted;
  final List<bool> weeklyCompletion; // 7 days, Mon-Sun

  const PrayerStreak({
    required this.currentStreak,
    required this.longestStreak,
    required this.totalPrayersCompleted,
    required this.weeklyCompletion,
  });

  @override
  List<Object?> get props => [
    currentStreak,
    longestStreak,
    totalPrayersCompleted,
    weeklyCompletion,
  ];
}
