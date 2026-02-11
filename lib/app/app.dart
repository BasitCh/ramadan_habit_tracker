import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ramadan_habit_tracker/app/router/app_router.dart';
import 'package:ramadan_habit_tracker/app/theme/app_theme.dart';
import 'package:ramadan_habit_tracker/di/injection_container.dart';
import 'package:ramadan_habit_tracker/features/dhikr/presentation/bloc/dhikr_bloc.dart';
import 'package:ramadan_habit_tracker/features/fasting/presentation/bloc/fasting_bloc.dart';
import 'package:ramadan_habit_tracker/features/habits/presentation/bloc/habit_bloc.dart';
import 'package:ramadan_habit_tracker/features/prayer/presentation/bloc/prayer_bloc.dart';
import 'package:ramadan_habit_tracker/features/quran/presentation/bloc/quran_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HabitBloc>(
          create: (_) => sl<HabitBloc>()..add(const LoadHabits()),
        ),
        BlocProvider<PrayerBloc>(
          create: (_) => sl<PrayerBloc>()..add(LoadPrayerLog(DateTime.now())),
        ),
        BlocProvider<QuranBloc>(
          create: (_) =>
              sl<QuranBloc>()..add(LoadQuranProgress(DateTime.now())),
        ),
        BlocProvider<FastingBloc>(
          create: (_) => sl<FastingBloc>()..add(const LoadFastingLogs()),
        ),
        BlocProvider<DhikrBloc>(
          create: (_) => sl<DhikrBloc>()..add(const LoadDhikrList()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Ramadan Habit Tracker',
        theme: AppTheme.light,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
