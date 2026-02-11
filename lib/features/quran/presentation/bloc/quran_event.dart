part of 'quran_bloc.dart';

sealed class QuranEvent extends Equatable {
  const QuranEvent();

  @override
  List<Object> get props => [];
}

class LoadQuranProgress extends QuranEvent {
  final DateTime date;

  const LoadQuranProgress(this.date);

  @override
  List<Object> get props => [date];
}

class UpdateJuz extends QuranEvent {
  final int juz;

  const UpdateJuz(this.juz);

  @override
  List<Object> get props => [juz];
}

class UpdatePagesRead extends QuranEvent {
  final int pages;

  const UpdatePagesRead(this.pages);

  @override
  List<Object> get props => [pages];
}
