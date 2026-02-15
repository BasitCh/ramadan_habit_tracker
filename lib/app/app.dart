import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ramadan_habit_tracker/app/router/app_router.dart';
import 'package:ramadan_habit_tracker/app/theme/app_theme.dart';
import 'package:ramadan_habit_tracker/core/constants/app_constants.dart';
import 'package:ramadan_habit_tracker/di/injection_container.dart';
import 'package:ramadan_habit_tracker/features/adhkar/presentation/bloc/adhkar_bloc.dart';
import 'package:ramadan_habit_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ramadan_habit_tracker/features/quran/presentation/bloc/quran_bloc.dart';
import 'package:ramadan_habit_tracker/features/dua/presentation/bloc/dua_bloc.dart';
import 'package:ramadan_habit_tracker/features/hadith/presentation/bloc/hadith_bloc.dart';
import 'package:ramadan_habit_tracker/features/ibadah/presentation/bloc/ibadah_bloc.dart';
import 'package:ramadan_habit_tracker/features/prayer/presentation/bloc/prayer_bloc.dart';
import 'package:ramadan_habit_tracker/features/prayer/presentation/bloc/prayer_event.dart';
import 'package:ramadan_habit_tracker/features/challenge/presentation/bloc/challenge_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
        BlocProvider<PrayerBloc>(
          create: (_) =>
              sl<PrayerBloc>()..add(const LoadPrayerTimesRequested()),
        ),
        BlocProvider<QuranBloc>(
          create: (_) =>
              sl<QuranBloc>()..add(const LoadQuranOverviewRequested()),
        ),
        BlocProvider<DuaBloc>(
          create: (_) => sl<DuaBloc>()..add(const LoadDailyDuaRequested()),
        ),
        BlocProvider<IbadahBloc>(
          create: (_) =>
              sl<IbadahBloc>()..add(const LoadIbadahChecklistRequested()),
        ),
        BlocProvider<HadithBloc>(
          create: (_) =>
              sl<HadithBloc>()..add(const LoadDailyHadithRequested()),
        ),
        BlocProvider<AdhkarBloc>(
          create: (_) => sl<AdhkarBloc>()
            ..add(
              const LoadAdhkarRequested(AppConstants.morningAdhkarCategory),
            ),
        ),
        BlocProvider<ChallengeBloc>(
          create: (_) => sl<ChallengeBloc>()
            ..add(
              LoadDailyChallengeRequested(AppConstants.getCurrentRamadanDay()),
            ),
        ),
      ],
      child: MaterialApp.router(
        title: 'Noor Planner',
        theme: AppTheme.light,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
