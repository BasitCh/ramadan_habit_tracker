import 'package:ramadan_habit_tracker/core/constants/app_constants.dart';

extension DateTimeExtensions on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  String get dateKey => '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';

  DateTime get dateOnly => DateTime(year, month, day);

  int? get ramadanDayNumber {
    final start = AppConstants.ramadanStart.dateOnly;
    final end = AppConstants.ramadanEnd.dateOnly;
    final current = dateOnly;

    if (current.isBefore(start) || current.isAfter(end)) return null;
    return current.difference(start).inDays + 1;
  }

  bool get isInRamadan => ramadanDayNumber != null;
}
