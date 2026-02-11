import 'package:equatable/equatable.dart';

class QuranProgress extends Equatable {
  final DateTime date;
  final int currentJuz;
  final int pagesRead;

  const QuranProgress({
    required this.date,
    required this.currentJuz,
    required this.pagesRead,
  });

  QuranProgress copyWith({int? currentJuz, int? pagesRead}) {
    return QuranProgress(
      date: date,
      currentJuz: currentJuz ?? this.currentJuz,
      pagesRead: pagesRead ?? this.pagesRead,
    );
  }

  @override
  List<Object> get props => [date, currentJuz, pagesRead];
}
