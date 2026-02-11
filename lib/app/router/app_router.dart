import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ramadan_habit_tracker/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:ramadan_habit_tracker/features/dhikr/presentation/pages/dhikr_counter_page.dart';
import 'package:ramadan_habit_tracker/features/fasting/presentation/pages/fasting_page.dart';
import 'package:ramadan_habit_tracker/features/habits/presentation/pages/habits_page.dart';
import 'package:ramadan_habit_tracker/features/prayer/presentation/pages/prayer_tracker_page.dart';
import 'package:ramadan_habit_tracker/features/quran/presentation/pages/quran_progress_page.dart';

class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => _ScaffoldWithNav(child: child),
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardPage(),
            ),
          ),
          GoRoute(
            path: '/prayers',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: PrayerTrackerPage(),
            ),
          ),
          GoRoute(
            path: '/quran',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: QuranProgressPage(),
            ),
          ),
          GoRoute(
            path: '/more',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: _MorePage(),
            ),
          ),
        ],
      ),
      // Full-screen routes (outside bottom nav)
      GoRoute(
        path: '/habits',
        builder: (context, state) => const HabitsPage(),
      ),
      GoRoute(
        path: '/fasting',
        builder: (context, state) => const FastingPage(),
      ),
      GoRoute(
        path: '/dhikr',
        builder: (context, state) => const DhikrCounterPage(),
      ),
    ],
  );
}

class _ScaffoldWithNav extends StatelessWidget {
  final Widget child;

  const _ScaffoldWithNav({required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/prayers')) return 1;
    if (location.startsWith('/quran')) return 2;
    if (location.startsWith('/more')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex(context),
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/');
            case 1:
              context.go('/prayers');
            case 2:
              context.go('/quran');
            case 3:
              context.go('/more');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mosque),
            label: 'Prayers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Quran',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
      ),
    );
  }
}

class _MorePage extends StatelessWidget {
  const _MorePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.checklist),
            title: const Text('My Habits'),
            subtitle: const Text('Track custom daily habits'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/habits'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.restaurant),
            title: const Text('Fasting Tracker'),
            subtitle: const Text('Log your daily fasts'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/fasting'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.touch_app),
            title: const Text('Dhikr Counter'),
            subtitle: const Text('Count your daily dhikr'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/dhikr'),
          ),
        ],
      ),
    );
  }
}
