import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'package:ramadan_habit_tracker/core/constants/app_constants.dart';
import 'package:ramadan_habit_tracker/core/services/location_service.dart';
import 'package:ramadan_habit_tracker/core/services/location_service_impl.dart';
import 'package:ramadan_habit_tracker/core/services/location_cache.dart';
import 'package:ramadan_habit_tracker/core/services/location_cache_model.dart';
import 'package:ramadan_habit_tracker/core/services/notification_service.dart';

// Auth
import 'package:ramadan_habit_tracker/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:ramadan_habit_tracker/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:ramadan_habit_tracker/features/auth/data/models/user_model.dart';
import 'package:ramadan_habit_tracker/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ramadan_habit_tracker/features/auth/domain/repositories/auth_repository.dart';
import 'package:ramadan_habit_tracker/features/auth/domain/usecases/check_auth_status.dart';
import 'package:ramadan_habit_tracker/features/auth/domain/usecases/logout.dart';
import 'package:ramadan_habit_tracker/features/auth/domain/usecases/send_otp.dart';
import 'package:ramadan_habit_tracker/features/auth/domain/usecases/sign_in_with_apple.dart';
import 'package:ramadan_habit_tracker/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:ramadan_habit_tracker/features/auth/domain/usecases/verify_otp.dart';
import 'package:ramadan_habit_tracker/features/auth/presentation/bloc/auth_bloc.dart';

// Prayer
import 'package:ramadan_habit_tracker/features/prayer/data/datasources/prayer_times_local_datasource.dart';
import 'package:ramadan_habit_tracker/features/prayer/data/datasources/prayer_times_remote_datasource.dart';
import 'package:ramadan_habit_tracker/features/prayer/data/models/prayer_log_model.dart';
import 'package:ramadan_habit_tracker/features/prayer/data/models/prayer_time_model.dart';
import 'package:ramadan_habit_tracker/features/prayer/data/repositories/prayer_repository_impl.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/repositories/prayer_repository.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/usecases/get_prayer_times.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/usecases/toggle_prayer_completion.dart';
import 'package:ramadan_habit_tracker/features/prayer/presentation/bloc/prayer_bloc.dart';

// Quran
import 'package:ramadan_habit_tracker/features/quran/data/datasources/quran_local_datasource.dart';
import 'package:ramadan_habit_tracker/features/quran/data/datasources/quran_text_local_datasource.dart';
import 'package:ramadan_habit_tracker/features/quran/data/datasources/quran_text_remote_datasource.dart';
import 'package:ramadan_habit_tracker/features/quran/data/models/quran_progress_model.dart';
import 'package:ramadan_habit_tracker/features/quran/data/models/surah_detail_cache_model.dart';
import 'package:ramadan_habit_tracker/features/quran/data/models/surah_list_cache_model.dart';
import 'package:ramadan_habit_tracker/features/quran/data/repositories/quran_repository_impl.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/repositories/quran_repository.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/usecases/get_quran_progress.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/usecases/get_surah_detail.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/usecases/get_surah_list.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/usecases/update_pages_read.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/usecases/reset_quran_progress.dart';
import 'package:ramadan_habit_tracker/features/quran/presentation/bloc/quran_bloc.dart';

// Dua
import 'package:ramadan_habit_tracker/features/dua/data/datasources/dua_local_datasource.dart';
import 'package:ramadan_habit_tracker/features/dua/data/models/dua_model.dart';
import 'package:ramadan_habit_tracker/features/dua/data/repositories/dua_repository_impl.dart';
import 'package:ramadan_habit_tracker/features/dua/domain/repositories/dua_repository.dart';
import 'package:ramadan_habit_tracker/features/dua/domain/usecases/get_daily_dua.dart';
import 'package:ramadan_habit_tracker/features/dua/presentation/bloc/dua_bloc.dart';

// Hadith
import 'package:ramadan_habit_tracker/features/hadith/data/datasources/hadith_local_data_source.dart';
import 'package:ramadan_habit_tracker/features/hadith/data/datasources/hadith_remote_data_source.dart';
import 'package:ramadan_habit_tracker/features/hadith/data/models/hadith_cache_model.dart';
import 'package:ramadan_habit_tracker/features/hadith/data/repositories/hadith_repository_impl.dart';
import 'package:ramadan_habit_tracker/features/hadith/domain/repositories/hadith_repository.dart';
import 'package:ramadan_habit_tracker/features/hadith/domain/usecases/get_daily_hadith.dart';
import 'package:ramadan_habit_tracker/features/hadith/presentation/bloc/hadith_bloc.dart';
// Ibadah
import 'package:ramadan_habit_tracker/features/ibadah/data/datasources/ibadah_local_datasource.dart';
import 'package:ramadan_habit_tracker/features/ibadah/data/models/ibadah_checklist_model.dart';
import 'package:ramadan_habit_tracker/features/ibadah/data/repositories/ibadah_repository_impl.dart';
import 'package:ramadan_habit_tracker/features/ibadah/domain/repositories/ibadah_repository.dart';
import 'package:ramadan_habit_tracker/features/ibadah/domain/usecases/get_ibadah_checklist.dart';
import 'package:ramadan_habit_tracker/features/ibadah/domain/usecases/toggle_ibadah_item.dart';
import 'package:ramadan_habit_tracker/features/ibadah/presentation/bloc/ibadah_bloc.dart';

// Adhkar
import 'package:ramadan_habit_tracker/features/adhkar/data/datasources/adhkar_local_datasource.dart';
import 'package:ramadan_habit_tracker/features/adhkar/data/models/adhkar_model.dart';
import 'package:ramadan_habit_tracker/features/adhkar/data/repositories/adhkar_repository_impl.dart';
import 'package:ramadan_habit_tracker/features/adhkar/domain/repositories/adhkar_repository.dart';
import 'package:ramadan_habit_tracker/features/adhkar/presentation/bloc/adhkar_bloc.dart';

// Challenge
import 'package:ramadan_habit_tracker/features/challenge/data/datasources/challenge_local_datasource.dart';
import 'package:ramadan_habit_tracker/features/challenge/data/repositories/challenge_repository_impl.dart';
import 'package:ramadan_habit_tracker/features/challenge/domain/repositories/challenge_repository.dart';
import 'package:ramadan_habit_tracker/features/challenge/presentation/bloc/challenge_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ══════════════════════════════════════════════════════════════════════════
  // External
  // ══════════════════════════════════════════════════════════════════════════

  sl.registerLazySingleton<Uuid>(() => const Uuid());
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  sl.registerLazySingleton<LocationService>(
    () => LocationServiceImpl(locationCache: sl()),
  );
  sl.registerLazySingleton<LocationCache>(() => LocationCacheImpl(sl()));

  sl.registerLazySingleton<NotificationService>(() => NotificationService());

  // ══════════════════════════════════════════════════════════════════════════
  // Hive Boxes
  // ══════════════════════════════════════════════════════════════════════════

  final userBox = await Hive.openBox<UserModel>(AppConstants.userBox);
  sl.registerLazySingleton<Box<UserModel>>(() => userBox);

  final prayerTimesBox = await Hive.openBox<PrayerTimeModel>(
    AppConstants.prayerTimesBox,
  );
  sl.registerLazySingleton<Box<PrayerTimeModel>>(() => prayerTimesBox);

  final prayerLogsBox = await Hive.openBox<PrayerLogModel>(
    AppConstants.prayerLogsBox,
  );
  sl.registerLazySingleton<Box<PrayerLogModel>>(() => prayerLogsBox);

  final quranProgressBox = await Hive.openBox<QuranProgressModel>(
    AppConstants.quranProgressBox,
  );
  sl.registerLazySingleton<Box<QuranProgressModel>>(() => quranProgressBox);

  final surahListBox = await Hive.openBox<SurahListCacheModel>(
    AppConstants.quranSurahListBox,
  );
  sl.registerLazySingleton<Box<SurahListCacheModel>>(() => surahListBox);

  final surahDetailBox = await Hive.openBox<SurahDetailCacheModel>(
    AppConstants.quranSurahDetailBox,
  );
  sl.registerLazySingleton<Box<SurahDetailCacheModel>>(() => surahDetailBox);

  final duasBox = await Hive.openBox<DuaModel>(AppConstants.duasBox);
  sl.registerLazySingleton<Box<DuaModel>>(() => duasBox);

  final adhkarBox = await Hive.openBox<AdhkarModel>(AppConstants.adhkarBox);
  sl.registerLazySingleton<Box<AdhkarModel>>(() => adhkarBox);

  final ibadahBox = await Hive.openBox<IbadahChecklistModel>(
    AppConstants.ibadahChecklistBox,
  );
  sl.registerLazySingleton<Box<IbadahChecklistModel>>(() => ibadahBox);

  final hadithBox = await Hive.openBox<HadithCacheModel>(
    AppConstants.hadithBox,
  );
  sl.registerLazySingleton<Box<HadithCacheModel>>(() => hadithBox);

  final locationCacheBox = await Hive.openBox<LocationCacheModel>(
    'location_cache',
  );
  sl.registerLazySingleton<Box<LocationCacheModel>>(() => locationCacheBox);

  // ══════════════════════════════════════════════════════════════════════════
  // Auth Feature
  // ══════════════════════════════════════════════════════════════════════════

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(firebaseAuth: sl(), googleSignIn: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(userBox: sl(), sharedPreferences: sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => SendOtp(sl()));
  sl.registerLazySingleton(() => VerifyOtp(sl()));
  sl.registerLazySingleton(() => SignInWithGoogle(sl()));
  sl.registerLazySingleton(() => SignInWithApple(sl()));
  sl.registerLazySingleton(() => CheckAuthStatus(sl()));
  sl.registerLazySingleton(() => Logout(sl()));

  // BLoC
  sl.registerFactory(
    () => AuthBloc(
      checkAuthStatus: sl(),
      sendOtp: sl(),
      verifyOtp: sl(),
      signInWithGoogle: sl(),
      signInWithApple: sl(),
      logout: sl(),
    ),
  );

  // ══════════════════════════════════════════════════════════════════════════
  // Prayer Feature
  // ══════════════════════════════════════════════════════════════════════════

  // Data Sources
  sl.registerLazySingleton<PrayerTimesRemoteDataSource>(
    () => PrayerTimesRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<PrayerTimesLocalDataSource>(
    () => PrayerTimesLocalDataSourceImpl(
      prayerTimesBox: sl(),
      prayerLogsBox: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<PrayerRepository>(
    () => PrayerRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      sharedPreferences: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetPrayerTimes(sl()));
  sl.registerLazySingleton(() => TogglePrayerCompletion(sl()));

  // BLoC
  sl.registerFactory(
    () => PrayerBloc(
      getPrayerTimes: sl(),
      togglePrayerCompletion: sl(),
      repository: sl(),
      locationService: sl(),
      notificationService: sl(),
    ),
  );

  // ══════════════════════════════════════════════════════════════════════════
  // Quran Feature
  // ══════════════════════════════════════════════════════════════════════════

  // Data Source
  sl.registerLazySingleton<QuranLocalDataSource>(
    () => QuranLocalDataSourceImpl(progressBox: sl()),
  );
  sl.registerLazySingleton<QuranTextRemoteDataSource>(
    () => QuranTextRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<QuranTextLocalDataSource>(
    () =>
        QuranTextLocalDataSourceImpl(surahListBox: sl(), surahDetailBox: sl()),
  );

  // Repository
  sl.registerLazySingleton<QuranRepository>(
    () => QuranRepositoryImpl(
      localDataSource: sl(),
      textRemoteDataSource: sl(),
      textLocalDataSource: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetQuranProgress(sl()));
  sl.registerLazySingleton(() => GetSurahList(sl()));
  sl.registerLazySingleton(() => GetSurahDetail(sl()));
  sl.registerLazySingleton(() => UpdatePagesRead(sl()));
  sl.registerLazySingleton(() => ResetQuranProgress(sl()));

  // BLoC
  sl.registerFactory(
    () => QuranBloc(
      getQuranProgress: sl(),
      updatePagesRead: sl(),
      getSurahList: sl(),
      getSurahDetail: sl(),
      resetQuranProgress: sl(),
    ),
  );

  // ══════════════════════════════════════════════════════════════════════════
  // Hadith Feature
  // ══════════════════════════════════════════════════════════════════════════

  sl.registerLazySingleton<HadithRemoteDataSource>(
    () => HadithRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<HadithLocalDataSource>(
    () => HadithLocalDataSourceImpl(hadithBox: sl()),
  );
  sl.registerLazySingleton<HadithRepository>(
    () => HadithRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetDailyHadith(sl()));
  sl.registerFactory(() => HadithBloc(getDailyHadith: sl()));

  // ══════════════════════════════════════════════════════════════════════════
  // Dua Feature
  // ══════════════════════════════════════════════════════════════════════════

  // Data Source
  sl.registerLazySingleton<DuaLocalDataSource>(
    () => DuaLocalDataSourceImpl(duasBox: sl(), sharedPreferences: sl()),
  );

  // Repository
  sl.registerLazySingleton<DuaRepository>(
    () => DuaRepositoryImpl(localDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetDailyDua(sl()));

  // BLoC
  sl.registerFactory(() => DuaBloc(getDailyDua: sl(), repository: sl()));

  // ══════════════════════════════════════════════════════════════════════════
  // Ibadah Feature
  // ══════════════════════════════════════════════════════════════════════════

  sl.registerLazySingleton<IbadahLocalDataSource>(
    () => IbadahLocalDataSourceImpl(checklistBox: sl()),
  );

  sl.registerLazySingleton<IbadahRepository>(
    () => IbadahRepositoryImpl(localDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetIbadahChecklist(sl()));
  sl.registerLazySingleton(() => ToggleIbadahItem(sl()));

  sl.registerFactory(
    () => IbadahBloc(getChecklist: sl(), toggleItem: sl(), repository: sl()),
  );

  // ══════════════════════════════════════════════════════════════════════════
  // Adhkar Feature
  // ══════════════════════════════════════════════════════════════════════════

  // Data Source
  sl.registerLazySingleton<AdhkarLocalDataSource>(
    () => AdhkarLocalDataSourceImpl(adhkarBox: sl()),
  );

  // Repository
  sl.registerLazySingleton<AdhkarRepository>(
    () => AdhkarRepositoryImpl(localDataSource: sl()),
  );

  // BLoC
  sl.registerFactory(() => AdhkarBloc(repository: sl()));

  // ══════════════════════════════════════════════════════════════════════════
  // Challenge Feature
  // ══════════════════════════════════════════════════════════════════════════

  // Data Source
  sl.registerLazySingleton<ChallengeLocalDataSource>(
    () => ChallengeLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Repository
  sl.registerLazySingleton<ChallengeRepository>(
    () => ChallengeRepositoryImpl(localDataSource: sl()),
  );

  // BLoC
  sl.registerFactory(() => ChallengeBloc(repository: sl()));

  // ══════════════════════════════════════════════════════════════════════════
  // Data Seeding
  // ══════════════════════════════════════════════════════════════════════════

  await _seedData();
}

Future<void> _seedData() async {
  // Seed duas if box is empty
  final duaDataSource = sl<DuaLocalDataSource>();
  final duasBox = sl<Box<DuaModel>>();
  if (duasBox.isEmpty) {
    await duaDataSource.seedFromJson(AppConstants.duasJsonPath);
  }

  // Seed adhkar if box is empty
  final adhkarDataSource = sl<AdhkarLocalDataSource>();
  final adhkarBox = sl<Box<AdhkarModel>>();
  if (adhkarBox.isEmpty) {
    await adhkarDataSource.seedFromJson(AppConstants.morningAdhkarJsonPath);
    await adhkarDataSource.seedFromJson(AppConstants.eveningAdhkarJsonPath);
  }
}
