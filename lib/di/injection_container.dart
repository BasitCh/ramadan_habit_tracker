import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'package:ramadan_habit_tracker/core/constants/app_constants.dart';

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
import 'package:ramadan_habit_tracker/features/quran/data/models/quran_progress_model.dart';
import 'package:ramadan_habit_tracker/features/quran/data/repositories/quran_repository_impl.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/repositories/quran_repository.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/usecases/get_quran_progress.dart';
import 'package:ramadan_habit_tracker/features/quran/domain/usecases/update_pages_read.dart';
import 'package:ramadan_habit_tracker/features/quran/presentation/bloc/quran_bloc.dart';

// Dua
import 'package:ramadan_habit_tracker/features/dua/data/datasources/dua_local_datasource.dart';
import 'package:ramadan_habit_tracker/features/dua/data/models/dua_model.dart';
import 'package:ramadan_habit_tracker/features/dua/data/repositories/dua_repository_impl.dart';
import 'package:ramadan_habit_tracker/features/dua/domain/repositories/dua_repository.dart';
import 'package:ramadan_habit_tracker/features/dua/domain/usecases/get_daily_dua.dart';
import 'package:ramadan_habit_tracker/features/dua/presentation/bloc/dua_bloc.dart';

// Adhkar
import 'package:ramadan_habit_tracker/features/adhkar/data/datasources/adhkar_local_datasource.dart';
import 'package:ramadan_habit_tracker/features/adhkar/data/models/adhkar_model.dart';
import 'package:ramadan_habit_tracker/features/adhkar/data/repositories/adhkar_repository_impl.dart';
import 'package:ramadan_habit_tracker/features/adhkar/domain/repositories/adhkar_repository.dart';
import 'package:ramadan_habit_tracker/features/adhkar/presentation/bloc/adhkar_bloc.dart';

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

  // ══════════════════════════════════════════════════════════════════════════
  // Hive Boxes
  // ══════════════════════════════════════════════════════════════════════════

  final userBox = await Hive.openBox<UserModel>(AppConstants.userBox);
  sl.registerLazySingleton<Box<UserModel>>(() => userBox);

  final prayerTimesBox = await Hive.openBox<PrayerTimeModel>(AppConstants.prayerTimesBox);
  sl.registerLazySingleton<Box<PrayerTimeModel>>(() => prayerTimesBox);

  final prayerLogsBox = await Hive.openBox<PrayerLogModel>(AppConstants.prayerLogsBox);
  sl.registerLazySingleton<Box<PrayerLogModel>>(() => prayerLogsBox);

  final quranProgressBox = await Hive.openBox<QuranProgressModel>(AppConstants.quranProgressBox);
  sl.registerLazySingleton<Box<QuranProgressModel>>(() => quranProgressBox);

  final duasBox = await Hive.openBox<DuaModel>(AppConstants.duasBox);
  sl.registerLazySingleton<Box<DuaModel>>(() => duasBox);

  final adhkarBox = await Hive.openBox<AdhkarModel>(AppConstants.adhkarBox);
  sl.registerLazySingleton<Box<AdhkarModel>>(() => adhkarBox);

  // ══════════════════════════════════════════════════════════════════════════
  // Auth Feature
  // ══════════════════════════════════════════════════════════════════════════

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(firebaseAuth: sl(), googleSignIn: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      userBox: sl(),
      sharedPreferences: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
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
    ),
  );

  // ══════════════════════════════════════════════════════════════════════════
  // Quran Feature
  // ══════════════════════════════════════════════════════════════════════════

  // Data Source
  sl.registerLazySingleton<QuranLocalDataSource>(
    () => QuranLocalDataSourceImpl(progressBox: sl()),
  );

  // Repository
  sl.registerLazySingleton<QuranRepository>(
    () => QuranRepositoryImpl(localDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetQuranProgress(sl()));
  sl.registerLazySingleton(() => UpdatePagesRead(sl()));

  // BLoC
  sl.registerFactory(
    () => QuranBloc(
      getQuranProgress: sl(),
      updatePagesRead: sl(),
    ),
  );

  // ══════════════════════════════════════════════════════════════════════════
  // Dua Feature
  // ══════════════════════════════════════════════════════════════════════════

  // Data Source
  sl.registerLazySingleton<DuaLocalDataSource>(
    () => DuaLocalDataSourceImpl(duasBox: sl()),
  );

  // Repository
  sl.registerLazySingleton<DuaRepository>(
    () => DuaRepositoryImpl(localDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetDailyDua(sl()));

  // BLoC
  sl.registerFactory(
    () => DuaBloc(getDailyDua: sl(), repository: sl()),
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
  sl.registerFactory(
    () => AdhkarBloc(repository: sl()),
  );

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
