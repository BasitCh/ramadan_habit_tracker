import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ramadan_habit_tracker/app/app.dart';
import 'package:ramadan_habit_tracker/di/injection_container.dart';
import 'package:ramadan_habit_tracker/features/adhkar/data/models/adhkar_model.dart';
import 'package:ramadan_habit_tracker/features/auth/data/models/user_model.dart';
import 'package:ramadan_habit_tracker/features/dua/data/models/dua_model.dart';
import 'package:ramadan_habit_tracker/features/hadith/data/models/hadith_cache_model.dart';
import 'package:ramadan_habit_tracker/features/ibadah/data/models/ibadah_checklist_model.dart';
import 'package:ramadan_habit_tracker/features/prayer/data/models/prayer_log_model.dart';
import 'package:ramadan_habit_tracker/features/prayer/data/models/prayer_time_model.dart';
import 'package:ramadan_habit_tracker/features/quran/data/models/quran_progress_model.dart';
import 'package:ramadan_habit_tracker/features/quran/data/models/surah_detail_cache_model.dart';
import 'package:ramadan_habit_tracker/features/quran/data/models/surah_list_cache_model.dart';
import 'package:ramadan_habit_tracker/core/services/location_cache_model.dart';
import 'package:ramadan_habit_tracker/core/services/notification_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Mobile Ads
  await MobileAds.instance.initialize();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(PrayerTimeModelAdapter());
  Hive.registerAdapter(PrayerLogModelAdapter());
  Hive.registerAdapter(QuranProgressModelAdapter());
  Hive.registerAdapter(DuaModelAdapter());
  Hive.registerAdapter(AdhkarModelAdapter());
  Hive.registerAdapter(IbadahChecklistModelAdapter());
  Hive.registerAdapter(HadithCacheModelAdapter());
  Hive.registerAdapter(SurahListCacheModelAdapter());
  Hive.registerAdapter(SurahDetailCacheModelAdapter());
  Hive.registerAdapter(LocationCacheModelAdapter());

  // Initialize dependency injection
  await initDependencies();

  // Initialize Notification Service
  await NotificationService().init();
  await NotificationService().requestPermissions();
  await NotificationService().scheduleDailyReminder();

  runApp(const App());
}
