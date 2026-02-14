import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ramadan_habit_tracker/app/theme/app_colors.dart';
import 'package:ramadan_habit_tracker/features/adhkar/presentation/pages/adhkar_page.dart';
import 'package:ramadan_habit_tracker/features/auth/presentation/pages/otp_verification_page.dart';
import 'package:ramadan_habit_tracker/features/auth/presentation/pages/phone_login_page.dart';
import 'package:ramadan_habit_tracker/features/dua/presentation/pages/dua_of_day_page.dart';
import 'package:ramadan_habit_tracker/features/guides/presentation/pages/guides_page.dart';
import 'package:ramadan_habit_tracker/features/guides/presentation/pages/guide_detail_page.dart';
import 'package:ramadan_habit_tracker/features/guides/presentation/data/guide_content.dart';
import 'package:ramadan_habit_tracker/features/home/presentation/pages/home_page.dart';
import 'package:ramadan_habit_tracker/features/prayer/presentation/pages/salah_tracker_page.dart';
import 'package:ramadan_habit_tracker/features/profile/presentation/pages/profile_page.dart';
import 'package:ramadan_habit_tracker/features/quran/presentation/pages/quran_progress_page.dart';
import 'package:ramadan_habit_tracker/features/quran/presentation/pages/surah_detail_page.dart';
import 'package:ramadan_habit_tracker/features/splash/presentation/pages/splash_page.dart';
import 'package:ramadan_habit_tracker/features/tasbeeh/presentation/pages/tasbeeh_page.dart';
import 'package:ramadan_habit_tracker/features/zakat/presentation/pages/zakat_page.dart';
import 'package:ramadan_habit_tracker/features/sunnah/presentation/pages/sunnah_page.dart';
import 'package:ramadan_habit_tracker/features/mosque/presentation/pages/masjid_locator_page.dart';

class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      // ── Public Routes ──────────────────────────────────────────────────
      GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
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
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomePage()),
          ),
          GoRoute(
            path: '/quran',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: QuranProgressPage()),
          ),
          GoRoute(
            path: '/guides',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: GuidesPage()),
          ),
          GoRoute(
            path: '/dua',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: DuaOfDayPage()),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ProfilePage()),
          ),
        ],
      ),

      // ── Full-Screen Routes ─────────────────────────────────────────────
      GoRoute(
        path: '/salah',
        builder: (context, state) => const SalahTrackerPage(),
      ),
      GoRoute(path: '/adhkar', builder: (context, state) => const AdhkarPage()),
      GoRoute(
        path: '/guides/zakat',
        builder: (context, state) => const ZakatPage(),
      ),
      GoRoute(
        path: '/guides/sunnah-library',
        builder: (context, state) => const SunnahPage(),
      ),
      GoRoute(
        path: '/guides/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          final entry = GuideContent.byId(id);
          if (entry == null) {
            return const GuidesPage();
          }
          return GuideDetailPage(entry: entry);
        },
      ),
      GoRoute(
        path: '/quran/surah/:id',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          if (id == null) {
            return const QuranProgressPage();
          }
          return SurahDetailPage(surahNumber: id);
        },
      ),
      GoRoute(
        path: '/tasbeeh',
        builder: (context, state) => const TasbeehPage(),
      ),
      GoRoute(
        path: '/masjid-locator',
        builder: (context, state) => const MasjidLocatorPage(),
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
    if (location.startsWith('/guides')) return 2;
    if (location.startsWith('/dua')) return 3;
    if (location.startsWith('/profile')) return 4;
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
              context.go('/guides');
            case 3:
              context.go('/dua');
            case 4:
              context.go('/profile');
          }
        },
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColors.primary.withValues(alpha: 0.1),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: AppColors.primary),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_stories_outlined),
            selectedIcon: Icon(Icons.auto_stories, color: AppColors.primary),
            label: 'Quran',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore, color: AppColors.secondary),
            label: 'Guides',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite, color: AppColors.primary),
            label: 'Duas',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: AppColors.primary),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
