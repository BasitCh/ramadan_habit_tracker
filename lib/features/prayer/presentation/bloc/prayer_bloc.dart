import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ramadan_habit_tracker/core/services/location_service.dart';
import 'package:ramadan_habit_tracker/core/constants/app_constants.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/usecases/get_prayer_times.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/usecases/toggle_prayer_completion.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/repositories/prayer_repository.dart';
import 'package:ramadan_habit_tracker/features/prayer/presentation/bloc/prayer_event.dart';
import 'package:ramadan_habit_tracker/features/prayer/presentation/bloc/prayer_state.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/entities/prayer_log.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/entities/prayer_time.dart';

import 'package:ramadan_habit_tracker/core/services/notification_service.dart';

class PrayerBloc extends Bloc<PrayerEvent, PrayerState> {
  final GetPrayerTimes getPrayerTimes;
  final TogglePrayerCompletion togglePrayerCompletion;
  final PrayerRepository repository;
  final LocationService locationService;
  final NotificationService notificationService;

  PrayerBloc({
    required this.getPrayerTimes,
    required this.togglePrayerCompletion,
    required this.repository,
    required this.locationService,
    required this.notificationService,
  }) : super(const PrayerInitial()) {
    on<LoadPrayerTimesRequested>(_onLoadPrayerTimes);
    on<TogglePrayerRequested>(_onTogglePrayer);
    on<LoadPrayerStreakRequested>(_onLoadStreak);
  }

  Future<void> _onLoadPrayerTimes(
    LoadPrayerTimesRequested event,
    Emitter<PrayerState> emit,
  ) async {
    // 1. Emit loading initially
    if (state is! PrayerLoaded) {
      emit(const PrayerLoading());
    }

    // 2. Try to load cached data for immediate display
    // We do this concurrently to be fast
    final cachedLocation = await locationService.getLastKnownLocation();
    final cachedTimesResult = await repository.getCachedPrayerTimes();

    // Default location (London) if nothing cached
    double lat = 51.5074;
    double lng = -0.1278;
    String locationLabel =
        '${AppConstants.defaultCity}, ${AppConstants.defaultCountry}';

    if (cachedLocation != null) {
      lat = cachedLocation.lat;
      lng = cachedLocation.lng;
      locationLabel =
          cachedLocation.city != null && cachedLocation.country != null
          ? '${cachedLocation.city}, ${cachedLocation.country}'
          : '${AppConstants.defaultCity}, ${AppConstants.defaultCountry}';
    }

    // If we have cached times, emit them immediately
    if (cachedTimesResult.isRight()) {
      final cachedTimes = cachedTimesResult.getOrElse(
        () => throw 'Unreachable',
      );
      final logResult = await repository.getPrayerLog(DateTime.now());
      final streakResult = await repository.getPrayerStreak();

      final log = logResult.getOrElse(
        () => PrayerLog(
          date: DateTime.now(),
          completedPrayers: {
            for (var name in AppConstants.prayerNames) name: false,
          },
        ),
      );
      final streak = streakResult.fold((_) => null, (s) => s);

      emit(
        PrayerLoaded(
          prayerTimes: cachedTimes.prayerTimes,
          prayerLog: log,
          streak: streak,
          hijriDate: cachedTimes.hijriDate,
          locationLabel: locationLabel,
        ),
      );
    }

    // 3. Fetch Fresh Data (Location & Times)
    try {
      final locationResult = await locationService.getCurrentLocation();

      locationResult.fold(
        (failure) {
          // If location fails, stick with cached/default lat/lng
        },
        (loc) {
          lat = loc.lat;
          lng = loc.lng;
          locationLabel = loc.city != null && loc.country != null
              ? '${loc.city}, ${loc.country}'
              : '${AppConstants.defaultCity}, ${AppConstants.defaultCountry}';
        },
      );

      final timesResult = await getPrayerTimes(
        GetPrayerTimesParams(
          lat: lat,
          lng: lng,
          date: DateTime.now(),
          method: AppConstants.defaultCalculationMethod,
        ),
      );

      // Re-fetch logs/streak to ensure they are consistent
      final logResult = await repository.getPrayerLog(DateTime.now());
      final streakResult = await repository.getPrayerStreak();

      timesResult.fold(
        (failure) {
          // Only emit error if we don't have cached data shown
          if (state is! PrayerLoaded) {
            emit(PrayerError(failure.message));
          }
        },
        (result) {
          final log = logResult.fold(
            (_) => PrayerLog(
              date: DateTime.now(),
              completedPrayers: {
                for (var name in AppConstants.prayerNames) name: false,
              },
            ),
            (log) => log,
          );
          final streak = streakResult.fold((_) => null, (s) => s);

          // Schedule notifications for upcoming prayers
          _schedulePrayerNotifications(result.prayerTimes);

          emit(
            PrayerLoaded(
              prayerTimes: result.prayerTimes,
              prayerLog: log,
              streak: streak,
              hijriDate: result.hijriDate,
              locationLabel: locationLabel,
            ),
          );
        },
      );
    } catch (e) {
      if (state is! PrayerLoaded) {
        emit(PrayerError(e.toString()));
      }
    }
  }

  Future<void> _onTogglePrayer(
    TogglePrayerRequested event,
    Emitter<PrayerState> emit,
  ) async {
    final currentState = state;
    if (currentState is! PrayerLoaded) return;

    final result = await togglePrayerCompletion(
      TogglePrayerParams(date: DateTime.now(), prayerName: event.prayerName),
    );

    result.fold((failure) => emit(PrayerError(failure.message)), (updatedLog) {
      // Update times with new completion status
      final updatedTimes = currentState.prayerTimes.map((t) {
        return t.copyWith(
          isCompleted: updatedLog.completedPrayers[t.name] ?? false,
        );
      }).toList();

      emit(
        currentState.copyWith(prayerTimes: updatedTimes, prayerLog: updatedLog),
      );
    });

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

  Future<void> _schedulePrayerNotifications(
    List<PrayerTime> prayerTimes,
  ) async {
    await notificationService.cancelAllNotifications();

    final now = DateTime.now();
    for (int i = 0; i < prayerTimes.length; i++) {
      final prayer = prayerTimes[i];
      final parts = prayer.time.split(':');
      if (parts.length != 2) continue;

      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1]);

      if (hour == null || minute == null) continue;

      final scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      if (scheduledTime.isAfter(now)) {
        await notificationService.scheduleNotification(
          id: i,
          title: 'Time for ${prayer.name}',
          body: 'It is now time for ${prayer.name} prayer.',
          scheduledTime: scheduledTime,
          payload: '/salah',
        );
      }
    }
  }
}
