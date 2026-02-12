import 'package:equatable/equatable.dart';

class QuranProgress extends Equatable {
  final int currentPage;
  final int pagesReadToday;
  final DateTime lastReadDate;

  const QuranProgress({
    required this.currentPage,
    required this.pagesReadToday,
    required this.lastReadDate,
  });

  int get currentJuz => (currentPage / 20).ceil().clamp(1, 30);
  double get overallProgress => currentPage / 604;
  double get juzProgress => (currentPage % 20) / 20;

  @override
  List<Object?> get props => [currentPage, pagesReadToday, lastReadDate];
}
