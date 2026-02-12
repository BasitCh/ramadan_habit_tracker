import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ramadan_habit_tracker/app/router/app_router.dart';
import 'package:ramadan_habit_tracker/app/theme/app_theme.dart';
import 'package:ramadan_habit_tracker/di/injection_container.dart';
import 'package:ramadan_habit_tracker/features/adhkar/presentation/bloc/adhkar_bloc.dart';
import 'package:ramadan_habit_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ramadan_habit_tracker/features/dua/presentation/bloc/dua_bloc.dart';
import 'package:ramadan_habit_tracker/features/prayer/presentation/bloc/prayer_bloc.dart';
import 'package:ramadan_habit_tracker/features/quran/presentation/bloc/quran_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>(),
        ),
        BlocProvider<PrayerBloc>(
          create: (_) => sl<PrayerBloc>(),
        ),
        BlocProvider<QuranBloc>(
          create: (_) => sl<QuranBloc>(),
        ),
        BlocProvider<DuaBloc>(
          create: (_) => sl<DuaBloc>(),
        ),
        BlocProvider<AdhkarBloc>(
          create: (_) => sl<AdhkarBloc>(),
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
