part of 'prayer_bloc.dart';

sealed class PrayerEvent extends Equatable {
  const PrayerEvent();

  @override
  List<Object> get props => [];
}

class LoadPrayerLog extends PrayerEvent {
  final DateTime date;

  const LoadPrayerLog(this.date);

  @override
  List<Object> get props => [date];
}

class TogglePrayerRequested extends PrayerEvent {
  final String prayerName;
  final DateTime date;

  const TogglePrayerRequested({required this.prayerName, required this.date});

  @override
  List<Object> get props => [prayerName, date];
}
