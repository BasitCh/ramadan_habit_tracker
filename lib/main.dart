import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ramadan_habit_tracker/app/app.dart';
import 'package:ramadan_habit_tracker/di/injection_container.dart';
import 'package:ramadan_habit_tracker/features/dhikr/data/models/dhikr_model.dart';
import 'package:ramadan_habit_tracker/features/fasting/data/models/fasting_day_model.dart';
import 'package:ramadan_habit_tracker/features/habits/data/models/habit_log_model.dart';
import 'package:ramadan_habit_tracker/features/habits/data/models/habit_model.dart';
import 'package:ramadan_habit_tracker/features/prayer/data/models/prayer_log_model.dart';
import 'package:ramadan_habit_tracker/features/quran/data/models/quran_progress_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(HabitModelAdapter());
  Hive.registerAdapter(HabitLogModelAdapter());
  Hive.registerAdapter(PrayerLogModelAdapter());
  Hive.registerAdapter(QuranProgressModelAdapter());
  Hive.registerAdapter(FastingDayModelAdapter());
  Hive.registerAdapter(DhikrModelAdapter());

  // Initialize dependency injection
  await initDependencies();

  runApp(const App());
}
