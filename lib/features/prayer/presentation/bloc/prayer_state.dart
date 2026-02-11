part of 'prayer_bloc.dart';

sealed class PrayerState extends Equatable {
  const PrayerState();

  @override
  List<Object> get props => [];
}

class PrayerInitial extends PrayerState {
  const PrayerInitial();
}

class PrayerLoading extends PrayerState {
  const PrayerLoading();
}

class PrayerLoaded extends PrayerState {
  final PrayerLog prayerLog;

  const PrayerLoaded(this.prayerLog);

  @override
  List<Object> get props => [prayerLog];
}

class PrayerError extends PrayerState {
  final String message;

  const PrayerError(this.message);

  @override
  List<Object> get props => [message];
}
