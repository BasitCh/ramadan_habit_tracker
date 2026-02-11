import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/entities/prayer_log.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/usecases/get_prayer_log.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/usecases/toggle_prayer.dart';

part 'prayer_event.dart';
part 'prayer_state.dart';

class PrayerBloc extends Bloc<PrayerEvent, PrayerState> {
  final GetPrayerLog getPrayerLog;
  final TogglePrayer togglePrayer;

  PrayerBloc({
    required this.getPrayerLog,
    required this.togglePrayer,
  }) : super(const PrayerInitial()) {
    on<LoadPrayerLog>(_onLoadPrayerLog);
    on<TogglePrayerRequested>(_onTogglePrayer);
  }

  Future<void> _onLoadPrayerLog(
    LoadPrayerLog event,
    Emitter<PrayerState> emit,
  ) async {
    emit(const PrayerLoading());
    final result = await getPrayerLog(event.date);
    result.fold(
      (failure) => emit(PrayerError(failure.message)),
      (log) => emit(PrayerLoaded(log)),
    );
  }

  Future<void> _onTogglePrayer(
    TogglePrayerRequested event,
    Emitter<PrayerState> emit,
  ) async {
    final result = await togglePrayer(
      TogglePrayerParams(date: event.date, prayerName: event.prayerName),
    );
    result.fold(
      (failure) => emit(PrayerError(failure.message)),
      (log) => emit(PrayerLoaded(log)),
    );
  }
}
