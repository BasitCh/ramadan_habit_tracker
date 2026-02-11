import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import 'package:ramadan_habit_tracker/core/constants/app_constants.dart';

// Habits
import 'package:ramadan_habit_tracker/features/habits/data/datasources/habit_local_datasource.dart';
import 'package:ramadan_habit_tracker/features/habits/data/models/habit_log_model.dart';
import 'package:ramadan_habit_tracker/features/habits/data/models/habit_model.dart';
import 'package:ramadan_habit_tracker/features/habits/data/repositories/habit_repository_impl.dart';
import 'package:ramadan_habit_tracker/features/habits/domain/repositories/habit_repository.dart';
import 'package:ramadan_habit_tracker/features/habits/domain/usecases/add_habit.dart';
import 'package:ramadan_habit_tracker/features/habits/domain/usecases/delete_habit.dart';
import 'package:ramadan_habit_tracker/features/habits/domain/usecases/get_habit_logs_for_date.dart';
import 'package:ramadan_habit_tracker/features/habits/domain/usecases/get_habits.dart';
import 'package:ramadan_habit_tracker/features/habits/domain/usecases/toggle_habit_log.dart';
import 'package:ramadan_habit_tracker/features/habits/presentation/bloc/habit_bloc.dart';

// Prayer
import 'package:ramadan_habit_tracker/features/prayer/data/datasources/prayer_local_datasource.dart';
import 'package:ramadan_habit_tracker/features/prayer/data/models/prayer_log_model.dart';
import 'package:ramadan_habit_tracker/features/prayer/data/repositories/prayer_repository_impl.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/repositories/prayer_repository.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/usecases/get_prayer_log.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/usecases/toggle_prayer.dart';
import 'package:ramadan_habit_tracker/features/prayer/presentation/bloc/prayer_bloc.dart';

// Quran
import 'package:ramadan_habit_tracker/features/quran/data/datasources/quran_local_datasource.dart';
import 'package:ramadan_habit_tracker/features/quran/data/models/quran_progress_model.dart';
import 'package:ramadan_habit_tracker/features/quran/data/repositories/quran_repository_impl.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/repositories/quran_repository.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/usecases/get_quran_progress.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/usecases/update_quran_progress.dart';
import 'package:ramadan_habit_tracker/features/quran/presentation/bloc/quran_bloc.dart';

// Fasting
import 'package:ramadan_habit_tracker/features/fasting/data/datasources/fasting_local_datasource.dart';
import 'package:ramadan_habit_tracker/features/fasting/data/models/fasting_day_model.dart';
import 'package:ramadan_habit_tracker/features/fasting/data/repositories/fasting_repository_impl.dart';
import 'package:ramadan_habit_tracker/features/fasting/domain/repositories/fasting_repository.dart';
import 'package:ramadan_habit_tracker/features/fasting/domain/usecases/get_fasting_logs.dart';
import 'package:ramadan_habit_tracker/features/fasting/domain/usecases/toggle_fasting.dart';
import 'package:ramadan_habit_tracker/features/fasting/presentation/bloc/fasting_bloc.dart';

// Dhikr
import 'package:ramadan_habit_tracker/features/dhikr/data/datasources/dhikr_local_datasource.dart';
import 'package:ramadan_habit_tracker/features/dhikr/data/models/dhikr_model.dart';
import 'package:ramadan_habit_tracker/features/dhikr/data/repositories/dhikr_repository_impl.dart';
import 'package:ramadan_habit_tracker/features/dhikr/domain/entities/dhikr.dart';
import 'package:ramadan_habit_tracker/features/dhikr/domain/repositories/dhikr_repository.dart';
import 'package:ramadan_habit_tracker/features/dhikr/domain/usecases/add_dhikr.dart';
import 'package:ramadan_habit_tracker/features/dhikr/domain/usecases/get_dhikr_list.dart';
import 'package:ramadan_habit_tracker/features/dhikr/domain/usecases/increment_dhikr.dart';
import 'package:ramadan_habit_tracker/features/dhikr/domain/usecases/reset_dhikr.dart';
import 'package:ramadan_habit_tracker/features/dhikr/presentation/bloc/dhikr_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ── External ──────────────────────────────────────────────────────────
  sl.registerLazySingleton<Uuid>(() => const Uuid());

  // ── Hive Boxes ────────────────────────────────────────────────────────
  final habitsBox = await Hive.openBox<HabitModel>(AppConstants.habitsBox);
  final habitLogsBox = await Hive.openBox<HabitLogModel>(AppConstants.habitLogsBox);
  final prayerLogsBox = await Hive.openBox<PrayerLogModel>(AppConstants.prayerLogsBox);
  final quranProgressBox = await Hive.openBox<QuranProgressModel>(AppConstants.quranProgressBox);
  final fastingLogsBox = await Hive.openBox<FastingDayModel>(AppConstants.fastingLogsBox);
  final dhikrBox = await Hive.openBox<DhikrModel>(AppConstants.dhikrBox);

  // ── Habits Feature ────────────────────────────────────────────────────
  sl.registerLazySingleton<HabitLocalDataSource>(
    () => HabitLocalDataSourceImpl(
      habitsBox: habitsBox,
      habitLogsBox: habitLogsBox,
      uuid: sl(),
    ),
  );
  sl.registerLazySingleton<HabitRepository>(
    () => HabitRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetHabits(sl()));
  sl.registerLazySingleton(() => AddHabit(sl()));
  sl.registerLazySingleton(() => DeleteHabit(sl()));
  sl.registerLazySingleton(() => ToggleHabitLog(sl()));
  sl.registerLazySingleton(() => GetHabitLogsForDate(sl()));
  sl.registerFactory(
    () => HabitBloc(
      getHabits: sl(),
      addHabit: sl(),
      deleteHabit: sl(),
      toggleHabitLog: sl(),
      getHabitLogsForDate: sl(),
      uuid: sl(),
    ),
  );

  // ── Prayer Feature ────────────────────────────────────────────────────
  sl.registerLazySingleton<PrayerLocalDataSource>(
    () => PrayerLocalDataSourceImpl(prayerLogsBox: prayerLogsBox),
  );
  sl.registerLazySingleton<PrayerRepository>(
    () => PrayerRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetPrayerLog(sl()));
  sl.registerLazySingleton(() => TogglePrayer(sl()));
  sl.registerFactory(
    () => PrayerBloc(
      getPrayerLog: sl(),
      togglePrayer: sl(),
    ),
  );

  // ── Quran Feature ─────────────────────────────────────────────────────
  sl.registerLazySingleton<QuranLocalDataSource>(
    () => QuranLocalDataSourceImpl(quranProgressBox: quranProgressBox),
  );
  sl.registerLazySingleton<QuranRepository>(
    () => QuranRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetQuranProgress(sl()));
  sl.registerLazySingleton(() => UpdateQuranProgress(sl()));
  sl.registerFactory(
    () => QuranBloc(
      getQuranProgress: sl(),
      updateQuranProgress: sl(),
    ),
  );

  // ── Fasting Feature ───────────────────────────────────────────────────
  sl.registerLazySingleton<FastingLocalDataSource>(
    () => FastingLocalDataSourceImpl(fastingLogsBox: fastingLogsBox),
  );
  sl.registerLazySingleton<FastingRepository>(
    () => FastingRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetFastingLogs(sl()));
  sl.registerLazySingleton(() => ToggleFasting(sl()));
  sl.registerFactory(
    () => FastingBloc(
      getFastingLogs: sl(),
      toggleFasting: sl(),
    ),
  );

  // ── Dhikr Feature ────────────────────────────────────────────────────
  sl.registerLazySingleton<DhikrLocalDataSource>(
    () => DhikrLocalDataSourceImpl(dhikrBox: dhikrBox),
  );
  sl.registerLazySingleton<DhikrRepository>(
    () => DhikrRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetDhikrList(sl()));
  sl.registerLazySingleton(() => IncrementDhikr(sl()));
  sl.registerLazySingleton(() => ResetDhikr(sl()));
  sl.registerLazySingleton(() => AddDhikr(sl()));
  sl.registerFactory(
    () => DhikrBloc(
      getDhikrList: sl(),
      incrementDhikr: sl(),
      resetDhikr: sl(),
      addDhikr: sl(),
      uuid: sl(),
    ),
  );

  // ── Seed default dhikr if box is empty ────────────────────────────────
  if (dhikrBox.isEmpty) {
    final uuid = sl<Uuid>();
    for (final item in AppConstants.defaultDhikr) {
      final model = DhikrModel.fromEntity(
        Dhikr(
          id: uuid.v4(),
          name: item['name'] as String,
          targetCount: item['target'] as int,
          currentCount: 0,
        ),
      );
      await dhikrBox.put(model.id, model);
    }
  }
}
