part of 'fasting_bloc.dart';

sealed class FastingState extends Equatable {
  const FastingState();

  @override
  List<Object> get props => [];
}

class FastingInitial extends FastingState {
  const FastingInitial();
}

class FastingLoading extends FastingState {
  const FastingLoading();
}

class FastingLoaded extends FastingState {
  final List<FastingDay> fastingDays;

  const FastingLoaded(this.fastingDays);

  int get completedCount => fastingDays.where((d) => d.completed).length;

  @override
  List<Object> get props => [fastingDays];
}

class FastingError extends FastingState {
  final String message;

  const FastingError(this.message);

  @override
  List<Object> get props => [message];
}
