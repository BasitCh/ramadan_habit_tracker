part of 'fasting_bloc.dart';

sealed class FastingEvent extends Equatable {
  const FastingEvent();

  @override
  List<Object> get props => [];
}

class LoadFastingLogs extends FastingEvent {
  const LoadFastingLogs();
}

class ToggleFastingRequested extends FastingEvent {
  final DateTime date;

  const ToggleFastingRequested(this.date);

  @override
  List<Object> get props => [date];
}
