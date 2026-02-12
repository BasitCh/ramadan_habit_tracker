import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ramadan_habit_tracker/core/constants/app_constants.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/usecases/get_prayer_times.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/usecases/toggle_prayer_completion.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/repositories/prayer_repository.dart';
import 'package:ramadan_habit_tracker/features/prayer/presentation/bloc/prayer_event.dart';
import 'package:ramadan_habit_tracker/features/prayer/presentation/bloc/prayer_state.dart';

class PrayerBloc extends Bloc<PrayerEvent, PrayerState> {
  final GetPrayerTimes getPrayerTimes;
  final TogglePrayerCompletion togglePrayerCompletion;
  final PrayerRepository repository;

  PrayerBloc({
    required this.getPrayerTimes,
    required this.togglePrayerCompletion,
    required this.repository,
  }) : super(const PrayerInitial()) {
    on<LoadPrayerTimesRequested>(_onLoadPrayerTimes);
    on<TogglePrayerRequested>(_onTogglePrayer);
    on<LoadPrayerStreakRequested>(_onLoadStreak);
  }

  Future<void> _onLoadPrayerTimes(
    LoadPrayerTimesRequested event,
    Emitter<PrayerState> emit,
  ) async {
    emit(const PrayerLoading());

    final timesResult = await getPrayerTimes(GetPrayerTimesParams(
      city: event.city ?? AppConstants.defaultCity,
      country: event.country ?? AppConstants.defaultCountry,
    ));

    final logResult = await repository.getPrayerLog(DateTime.now());
    final streakResult = await repository.getPrayerStreak();

    timesResult.fold(
      (failure) => emit(PrayerError(failure.message)),
      (times) {
        final log = logResult.fold((_) => null, (log) => log);
        final streak = streakResult.fold((_) => null, (s) => s);

        if (log != null) {
          emit(PrayerLoaded(
            prayerTimes: times,
            prayerLog: log,
            streak: streak,
          ));
        } else {
          emit(PrayerError('Failed to load prayer log'));
        }
      },
    );
  }

  Future<void> _onTogglePrayer(
    TogglePrayerRequested event,
    Emitter<PrayerState> emit,
  ) async {
    final currentState = state;
    if (currentState is! PrayerLoaded) return;

    final result = await togglePrayerCompletion(TogglePrayerParams(
      date: DateTime.now(),
      prayerName: event.prayerName,
    ));

    result.fold(
      (failure) => emit(PrayerError(failure.message)),
      (updatedLog) {
        // Update times with new completion status
        final updatedTimes = currentState.prayerTimes.map((t) {
          return t.copyWith(
            isCompleted: updatedLog.completedPrayers[t.name] ?? false,
          );
        }).toList();

        emit(currentState.copyWith(
          prayerTimes: updatedTimes,
          prayerLog: updatedLog,
        ));
      },
    );

    // Refresh streak after toggle
    add(const LoadPrayerStreakRequested());
  }

  Future<void> _onLoadStreak(
    LoadPrayerStreakRequested event,
    Emitter<PrayerState> emit,
  ) async {
    final currentState = state;
    if (currentState is! PrayerLoaded) return;

    final result = await repository.getPrayerStreak();
    result.fold(
      (_) {},
      (streak) => emit(currentState.copyWith(streak: streak)),
    );
  }
}
