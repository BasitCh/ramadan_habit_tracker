import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ramadan_habit_tracker/app/theme/app_colors.dart';
import 'package:ramadan_habit_tracker/core/constants/app_constants.dart';
import 'package:ramadan_habit_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ramadan_habit_tracker/features/auth/presentation/bloc/auth_event.dart';
import 'package:ramadan_habit_tracker/features/auth/presentation/bloc/auth_state.dart';
import 'package:ramadan_habit_tracker/features/prayer/presentation/bloc/prayer_bloc.dart';
import 'package:ramadan_habit_tracker/features/prayer/presentation/bloc/prayer_event.dart';
import 'package:ramadan_habit_tracker/features/prayer/presentation/bloc/prayer_state.dart';
import 'package:ramadan_habit_tracker/features/quran/presentation/bloc/quran_bloc.dart';
import 'package:ramadan_habit_tracker/features/ibadah/presentation/bloc/ibadah_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Load prayer streak/stats
    context.read<PrayerBloc>().add(const LoadPrayerStreakRequested());
    // Quran progress might be loaded, but ensure we have it
    // We use LoadQuranOverview which is lightweight if data is cached
    // Or just check if state is loaded. But triggering it is safe.
    // However, QuranBloc doesn't have a specific "Load just progress" that isn't 'LoadQuranProgressRequested'
    // Let's use LoadQuranProgressRequested
    context.read<QuranBloc>().add(const LoadQuranProgressRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          context.go('/login');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              const SizedBox(height: 16),
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildSpiritualProgress(),
              const SizedBox(height: 24),
              _buildStatsGrid(),
              const SizedBox(height: 24),
              _buildActivityLog(),
              const SizedBox(height: 24),
              _buildQuoteCard(),
              const SizedBox(height: 24),
              _buildLogoutButton(context),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state is Authenticated ? state.user : null;
        final name = user?.displayName ?? 'User';
        final identifier = user?.email ?? user?.phoneNumber ?? '';
        final photoUrl = user?.photoUrl;

        return Row(
          children: [
            // Avatar with gradient ring
            Stack(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: CircleAvatar(
                      backgroundColor: AppColors.primaryLight,
                      backgroundImage: photoUrl != null
                          ? NetworkImage(photoUrl)
                          : null,
                      child: photoUrl == null
                          ? const Icon(
                              Icons.person,
                              color: AppColors.primary,
                              size: 28,
                            )
                          : null,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.background, width: 2),
                    ),
                    child: const Text(
                      'PRO',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RAMADAN KAREEM',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name.isNotEmpty ? name : 'User',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (identifier.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      identifier,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSpiritualProgress() {
    final currentDay = AppConstants.getCurrentRamadanDay();
    final totalDays = AppConstants.totalRamadanDays;
    // Ensure accurate progress calculation, clamping between 0 and 1
    final progress = (currentDay / totalDays).clamp(0.0, 1.0);
    final percentage = (progress * 100).toInt();

    String statusText = "Keep it up! You're making progress.";
    if (currentDay > 20) {
      statusText = "Last 10 Days! Maximize your efforts.";
    } else if (currentDay > 10) {
      statusText = "You're in the second Ashra of Forgiveness.";
    } else if (currentDay >= 1) {
      statusText = "First Ashra of Mercy. Start strong!";
    } else {
      statusText = "Ramadan is coming soon. Prepare your heart.";
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SPIRITUAL PROGRESS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.8),
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentDay > 0 && currentDay <= 30
                        ? 'Ramadan Day $currentDay'
                        : 'Pre-Ramadan',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Text(
                '$percentage%',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 10,
              fontStyle: FontStyle.italic,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: BlocBuilder<PrayerBloc, PrayerState>(
                builder: (context, state) {
                  String value = '0';
                  if (state is PrayerLoaded && state.streak != null) {
                    value = state.streak!.totalPrayersCompleted.toString();
                  } else if (state is PrayerLoaded && state.streak == null) {
                    // Start loading streak if not present?
                    // It should be loaded by initState
                  }

                  return _StatCard(
                    icon: Icons.star_rate,
                    iconBgColor: AppColors.primary.withValues(alpha: 0.2),
                    iconColor: AppColors.primary,
                    label: 'TOTAL SALAH',
                    labelColor: AppColors.primary,
                    value: value,
                    bgColor: AppColors.primary.withValues(alpha: 0.08),
                    borderColor: AppColors.primary.withValues(alpha: 0.15),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: BlocBuilder<QuranBloc, QuranState>(
                builder: (context, state) {
                  String value = '1';
                  if (state is QuranLoaded && state.progress != null) {
                    value = state.progress!.currentJuz.toString();
                  }

                  return _StatCard(
                    icon: Icons.auto_stories,
                    iconBgColor: AppColors.secondary.withValues(alpha: 0.2),
                    iconColor: AppColors.secondary,
                    label: 'QURAN JUZ',
                    labelColor: AppColors.secondary,
                    value: value,
                    bgColor: AppColors.secondary.withValues(alpha: 0.08),
                    borderColor: AppColors.secondary.withValues(alpha: 0.15),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: BlocBuilder<IbadahBloc, IbadahState>(
                builder: (context, state) {
                  String value = '0';
                  if (state is IbadahLoaded) {
                    value = state.totalCharityActs.toString();
                  }

                  return _StatCard(
                    icon: Icons.volunteer_activism,
                    iconBgColor: AppColors.secondary.withValues(alpha: 0.2),
                    iconColor: AppColors.secondary,
                    label: 'CHARITY ACTS',
                    labelColor: AppColors.secondary,
                    value: value,
                    bgColor: AppColors.secondary.withValues(alpha: 0.08),
                    borderColor: AppColors.secondary.withValues(alpha: 0.15),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: BlocBuilder<PrayerBloc, PrayerState>(
                builder: (context, state) {
                  String value = '0';
                  if (state is PrayerLoaded && state.streak != null) {
                    value = state.streak!.longestStreak.toString();
                  }

                  return _StatCard(
                    icon: Icons.local_fire_department,
                    iconBgColor: AppColors.primary.withValues(alpha: 0.2),
                    iconColor: AppColors.primary,
                    label: 'BEST STREAK',
                    labelColor: AppColors.primary,
                    value: value,
                    suffix: 'days',
                    bgColor: AppColors.primary.withValues(alpha: 0.08),
                    borderColor: AppColors.primary.withValues(alpha: 0.15),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActivityLog() {
    return BlocBuilder<PrayerBloc, PrayerState>(
      builder: (context, prayerState) {
        return BlocBuilder<QuranBloc, QuranState>(
          builder: (context, quranState) {
            final List<Widget> activityItems = [];

            // 1. Prayer Activities
            if (prayerState is PrayerLoaded) {
              final log = prayerState.prayerLog;
              final completed = log.completedPrayers.entries
                  .where((e) => e.value)
                  .toList();

              // Show last 2 completed prayers to avoid clutter
              // Since map is unordered, we just take ones we find.
              //Ideally we'd have timestamps.
              for (var entry in completed.take(2)) {
                activityItems.add(
                  _buildActivityItem(
                    icon: Icons.done_all,
                    iconColor: AppColors.primary,
                    title: '${entry.key} Prayer',
                    subtitle: 'Completed Today',
                    points: '+10 pts',
                    pointsColor: AppColors.primary,
                  ),
                );
                activityItems.add(const SizedBox(height: 12));
              }
            }

            // 2. Quran Activities
            if (quranState is QuranLoaded && quranState.progress != null) {
              final pagesToday = quranState.progress!.pagesReadToday;
              if (pagesToday > 0) {
                activityItems.add(
                  _buildActivityItem(
                    icon: Icons.menu_book,
                    iconColor: AppColors.secondary,
                    title: 'Quran Reading',
                    subtitle: 'Read $pagesToday pages today',
                    points: '+${pagesToday * 5} pts', // 5 pts per page
                    pointsColor: AppColors.secondary,
                  ),
                );
                activityItems.add(const SizedBox(height: 12));
              }
            }

            // If empty, show placeholder
            if (activityItems.isEmpty) {
              activityItems.add(
                _buildActivityItem(
                  icon: Icons.hourglass_empty,
                  iconColor: Colors.grey,
                  title: 'No activity yet',
                  subtitle: 'Start your worship today',
                  points: '',
                  pointsColor: Colors.transparent,
                ),
              );
            } else {
              // Remove last SizedBox
              if (activityItems.isNotEmpty && activityItems.last is SizedBox) {
                activityItems.removeLast();
              }
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'ACTIVITY LOG',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...activityItems,
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String points,
    required Color pointsColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconColor.withValues(alpha: 0.1),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
                ),
              ],
            ),
          ),
          if (points.isNotEmpty)
            Text(
              points,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: pointsColor,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuoteCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.format_quote,
            color: AppColors.primary.withValues(alpha: 0.5),
            size: 28,
          ),
          const SizedBox(height: 12),
          Text(
            '"The most beloved of deeds to Allah are those that are most consistent, even if they are small."',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '— PROPHET MUHAMMAD (\uFDFA)',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              color: AppColors.secondary,
              letterSpacing: 3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Logout'),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    context.read<AuthBloc>().add(const LogoutRequested());
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: AppColors.error),
                  ),
                ),
              ],
            ),
          );
        },
        icon: const Icon(Icons.logout, color: AppColors.error),
        label: const Text('Logout', style: TextStyle(color: AppColors.error)),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.error.withValues(alpha: 0.3)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String label;
  final Color labelColor;
  final String value;
  final String? suffix;
  final Color bgColor;
  final Color borderColor;

  const _StatCard({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.label,
    required this.labelColor,
    required this.value,
    this.suffix,
    required this.bgColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: labelColor,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              if (suffix != null) ...[
                const SizedBox(width: 4),
                Text(
                  suffix!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
