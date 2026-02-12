import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ramadan_habit_tracker/app/theme/app_colors.dart';
import 'package:ramadan_habit_tracker/features/adhkar/presentation/pages/adhkar_page.dart';
import 'package:ramadan_habit_tracker/features/auth/presentation/pages/otp_verification_page.dart';
import 'package:ramadan_habit_tracker/features/auth/presentation/pages/phone_login_page.dart';
import 'package:ramadan_habit_tracker/features/dua/presentation/pages/dua_of_day_page.dart';
import 'package:ramadan_habit_tracker/features/home/presentation/pages/home_page.dart';
import 'package:ramadan_habit_tracker/features/prayer/presentation/pages/salah_tracker_page.dart';
import 'package:ramadan_habit_tracker/features/profile/presentation/pages/profile_page.dart';
import 'package:ramadan_habit_tracker/features/quran/presentation/pages/quran_progress_page.dart';
import 'package:ramadan_habit_tracker/features/splash/presentation/pages/splash_page.dart';

class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      // ── Public Routes ──────────────────────────────────────────────────
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const PhoneLoginPage(),
      ),
      GoRoute(
        path: '/verify-otp',
        builder: (context, state) {
          final extra = state.extra as Map<String, String>? ?? {};
          return OtpVerificationPage(
            verificationId: extra['verificationId'] ?? '',
            phoneNumber: extra['phoneNumber'] ?? '',
          );
        },
      ),

      // ── Protected Routes with Bottom Nav ───────────────────────────────
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => _ScaffoldWithNav(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomePage(),
            ),
          ),
          GoRoute(
            path: '/quran',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: QuranProgressPage(),
            ),
          ),
          GoRoute(
            path: '/dua',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DuaOfDayPage(),
            ),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfilePage(),
            ),
          ),
        ],
      ),

      // ── Full-Screen Routes ─────────────────────────────────────────────
      GoRoute(
        path: '/salah',
        builder: (context, state) => const SalahTrackerPage(),
      ),
      GoRoute(
        path: '/adhkar',
        builder: (context, state) => const AdhkarPage(),
      ),
    ],
  );
}

class _ScaffoldWithNav extends StatelessWidget {
  final Widget child;

  const _ScaffoldWithNav({required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/quran')) return 1;
    if (location.startsWith('/dua')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex(context),
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/home');
            case 1:
              context.go('/quran');
            case 2:
              context.go('/dua');
            case 3:
              context.go('/profile');
          }
        },
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColors.primary.withValues(alpha: 0.2),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: AppColors.primaryDark),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book, color: AppColors.primaryDark),
            label: 'Quran',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite, color: AppColors.primaryDark),
            label: 'Dua',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: AppColors.primaryDark),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
