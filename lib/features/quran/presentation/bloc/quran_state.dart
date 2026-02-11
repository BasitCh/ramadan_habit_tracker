part of 'quran_bloc.dart';

sealed class QuranState extends Equatable {
  const QuranState();

  @override
  List<Object> get props => [];
}

class QuranInitial extends QuranState {
  const QuranInitial();
}

class QuranLoading extends QuranState {
  const QuranLoading();
}

class QuranLoaded extends QuranState {
  final QuranProgress progress;

  const QuranLoaded(this.progress);

  @override
  List<Object> get props => [progress];
}

class QuranError extends QuranState {
  final String message;

  const QuranError(this.message);

  @override
  List<Object> get props => [message];
}
