import 'package:equatable/equatable.dart';

class HijriDate extends Equatable {
  final String day;
  final String monthEn;
  final String monthAr;
  final String year;
  final String weekdayEn;
  final String weekdayAr;

  const HijriDate({
    required this.day,
    required this.monthEn,
    required this.monthAr,
    required this.year,
    required this.weekdayEn,
    required this.weekdayAr,
  });

  @override
  List<Object> get props => [day, monthEn, monthAr, year, weekdayEn, weekdayAr];
}
