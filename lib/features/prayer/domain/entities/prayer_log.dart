import 'package:equatable/equatable.dart';

class PrayerLog extends Equatable {
  final DateTime date;
  final Map<String, bool> completedPrayers; // prayerName -> isCompleted

  const PrayerLog({
    required this.date,
    required this.completedPrayers,
  });

  int get completedCount => completedPrayers.values.where((v) => v).length;
  int get totalCount => completedPrayers.length;
  bool get isAllCompleted => completedCount == totalCount;

  PrayerLog copyWith({
    DateTime? date,
    Map<String, bool>? completedPrayers,
  }) {
    return PrayerLog(
      date: date ?? this.date,
      completedPrayers: completedPrayers ?? this.completedPrayers,
    );
  }

  @override
  List<Object?> get props => [date, completedPrayers];
}
