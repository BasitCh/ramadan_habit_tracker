import 'package:equatable/equatable.dart';

sealed class PrayerEvent extends Equatable {
  const PrayerEvent();

  @override
  List<Object?> get props => [];
}

class LoadPrayerTimesRequested extends PrayerEvent {
  final String? city;
  final String? country;

  const LoadPrayerTimesRequested({this.city, this.country});

  @override
  List<Object?> get props => [city, country];
}

class TogglePrayerRequested extends PrayerEvent {
  final String prayerName;

  const TogglePrayerRequested(this.prayerName);

  @override
  List<Object> get props => [prayerName];
}

class LoadPrayerStreakRequested extends PrayerEvent {
  const LoadPrayerStreakRequested();
}
