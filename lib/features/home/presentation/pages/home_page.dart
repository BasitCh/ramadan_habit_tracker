import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ramadan_habit_tracker/app/theme/app_colors.dart';
import 'package:ramadan_habit_tracker/core/ads/ad_helper.dart';
import 'package:ramadan_habit_tracker/core/presentation/widgets/clay_card.dart';
import 'package:ramadan_habit_tracker/core/constants/app_constants.dart';
import 'package:ramadan_habit_tracker/features/prayer/domain/entities/prayer_time.dart';
import 'package:ramadan_habit_tracker/features/prayer/presentation/bloc/prayer_bloc.dart';
import 'package:ramadan_habit_tracker/features/prayer/presentation/bloc/prayer_state.dart';
import 'package:ramadan_habit_tracker/features/ibadah/presentation/bloc/ibadah_bloc.dart';
import 'package:ramadan_habit_tracker/features/hadith/presentation/bloc/hadith_bloc.dart';
import 'package:ramadan_habit_tracker/features/quran/presentation/bloc/quran_bloc.dart';
import 'package:ramadan_habit_tracker/features/challenge/presentation/bloc/challenge_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BannerAd? _bannerAd;
  bool _isBannerReady = false;
  Timer? _clockTimer;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: AdHelper.homeBannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (!mounted) return;
          setState(() => _isBannerReady = true);
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('BannerAd failed to load: $error');
          ad.dispose();
        },
      ),
    )..load();
    _clockTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (!mounted) return;
      setState(() {});
    });

    // Initialize challenge day
    final now = DateTime.now();
    final start = AppConstants.ramadanStart;
    int day = now.difference(start).inDays + 1;
    if (day < 1) day = 1;
    if (day > 30) day = 30;
    _selectedChallengeDay = day;

    // Load initial map position (defaults to London, updates with location)
    _loadMapLocation();
  }

  Future<void> _loadMapLocation() async {
    // We can reuse LocationService from DI if available, or just use a default
    // Since we don't have direct access to LocationService here without looking up via GetIt
    // Let's rely on PrayerBloc's location if possible or just default.
    // Better: Use `sl<LocationService>()` if imported.
    // For now, default to London.
    _initialMapPosition = const CameraPosition(
      target: LatLng(51.5074, -0.1278),
      zoom: 14,
    );
  }

  int _selectedChallengeDay = 1;
  final Completer<GoogleMapController> _mapController = Completer();
  CameraPosition? _initialMapPosition;

  @override
  void dispose() {
    _bannerAd?.dispose();
    _clockTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: [
            const SizedBox(height: 16),
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildHeroCard(context),
            const SizedBox(height: 20),
            _buildPrayerTracker(context),
            const SizedBox(height: 20),
            _buildQuickActions(context),
            const SizedBox(height: 20),
            _buildRamadanChallenge(),
            const SizedBox(height: 20),
            _buildHadithCard(),
            const SizedBox(height: 20),
            _buildIbadahChecklist(),
            const SizedBox(height: 20),
            _buildQuranCard(context),
            const SizedBox(height: 20),
            _buildNearbyMasjids(),
            if (_isBannerReady) ...[
              const SizedBox(height: 24),
              _buildBannerAd(),
            ],
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ASSALAMU ALAIKUM,',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.secondary.withValues(alpha: 0.6),
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Ahmed Ali',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        Container(
          width: 48,
          height: 48,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 2),
            color: Colors.white,
          ),
          child: const CircleAvatar(
            backgroundColor: AppColors.primaryLight,
            child: Icon(Icons.person, color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    return BlocBuilder<PrayerBloc, PrayerState>(
      builder: (context, state) {
        String nextPrayerName = 'Maghrib';
        String countdown = '2h 14m';
        String locationLabel = 'London, UK';
        String hijriBadge = 'Hijri Date';

        if (state is PrayerLoaded) {
          final next = _resolveNextPrayer(state.prayerTimes);
          if (next != null) {
            nextPrayerName = next.name;
            countdown = _formatCountdown(next.time);
          }
          locationLabel = state.locationLabel ?? locationLabel;

          final now = DateTime.now();
          final start = AppConstants.ramadanStart;
          final end = AppConstants.ramadanEnd;

          // Check if it's Ramadan time or approaching
          if (now.isBefore(start)) {
            final days = start.difference(now).inDays + 1;
            hijriBadge = '$days Days to Ramadan';
          } else if (now.isBefore(end)) {
            final day = now.difference(start).inDays + 1;
            hijriBadge = 'Ramadan Day $day';
          } else if (state.hijriDate != null) {
            final hijri = state.hijriDate!;
            hijriBadge = '${hijri.day} ${hijri.monthEn} ${hijri.year}';
          }
        }

        return GestureDetector(
          onTap: () => context.push('/salah'),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                colors: [AppColors.gradientStart, AppColors.gradientEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondary.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [_heroBadge(hijriBadge)]),
                    const SizedBox(height: 16),
                    Text(
                      'Next Prayer',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$nextPrayerName in $countdown',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          locationLabel,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  right: -24,
                  bottom: -24,
                  child: Icon(
                    Icons.settings_input_component,
                    size: 140,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _heroBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildPrayerTracker(BuildContext context) {
    return BlocBuilder<PrayerBloc, PrayerState>(
      builder: (context, state) {
        int completed = 0;
        Map<String, bool> prayers = {
          'Fajr': false,
          'Dhuhr': false,
          'Asr': false,
          'Maghrib': false,
          'Isha': false,
        };

        if (state is PrayerLoaded) {
          prayers = Map<String, bool>.from(state.prayerLog.completedPrayers);
          completed = prayers.values.where((v) => v).length;
        }

        return GestureDetector(
          onTap: () => context.push('/salah'),
          child: ClayCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Prayer Tracker',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.chevron_right,
                          color: Colors.grey.shade400,
                          size: 18,
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$completed/5 Completed',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: prayers.entries.map((entry) {
                    final isDone = entry.value;
                    return Column(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: isDone
                                ? AppColors.secondary
                                : Colors.grey.shade50,
                            border: isDone
                                ? null
                                : Border.all(
                                    color: Colors.grey.shade200,
                                    width: 2,
                                    strokeAlign: BorderSide.strokeAlignInside,
                                  ),
                            boxShadow: isDone
                                ? [
                                    BoxShadow(
                                      color: AppColors.secondary.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Icon(
                            isDone ? Icons.check : Icons.radio_button_unchecked,
                            color: isDone ? Colors.white : Colors.grey.shade300,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          entry.key,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isDone
                                ? AppColors.textPrimary.withValues(alpha: 0.6)
                                : AppColors.textPrimary.withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ClayCard(
            onTap: () => context.push('/adhkar'),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.primaryLight,
                  ),
                  child: const Icon(
                    Icons.access_time_filled,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Morning & Evening',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Adhkar',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ClayCard(
            onTap: () => context.push('/tasbeeh'),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.secondary.withValues(alpha: 0.08),
                  ),
                  child: const Icon(
                    Icons.fingerprint,
                    color: AppColors.secondary,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '3D Tasbeeh',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Counter',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRamadanChallenge() {
    return BlocBuilder<ChallengeBloc, ChallengeState>(
      builder: (context, state) {
        if (state is! ChallengeLoaded) {
          return const SizedBox.shrink();
        }

        // Use selected day instead of auto-calculated only
        // Find challenge for selected day
        final challenge = state.challenges.firstWhere(
          (c) => c.day == _selectedChallengeDay,
          orElse: () => state.challenges.first,
        );

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [AppColors.gradientStart, AppColors.gradientEnd],
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
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                child: Icon(
                  Icons.military_tech,
                  size: 64,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          '30 Day Challenge',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.chevron_left,
                              color: Colors.white,
                            ),
                            onPressed: _selectedChallengeDay > 1
                                ? () => setState(() => _selectedChallengeDay--)
                                : null,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Day $_selectedChallengeDay',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                            ),
                            onPressed: _selectedChallengeDay < 30
                                ? () => setState(() => _selectedChallengeDay++)
                                : null,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "TODAY'S CHALLENGE",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withValues(alpha: 0.8),
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (challenge.isCompleted) {
                              context.read<ChallengeBloc>().add(
                                UncompleteChallengeRequested(challenge.day),
                              );
                            } else {
                              context.read<ChallengeBloc>().add(
                                CompleteChallengeRequested(challenge.day),
                              );
                            }
                          },
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: challenge.isCompleted
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              challenge.isCompleted
                                  ? Icons.check
                                  : Icons.auto_awesome,
                              color: challenge.isCompleted
                                  ? AppColors.primary
                                  : Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                challenge.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.white.withValues(
                                    alpha: challenge.isCompleted ? 0.6 : 1.0,
                                  ),
                                  decoration: challenge.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                  decorationColor: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                challenge.description,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHadithCard() {
    return BlocBuilder<HadithBloc, HadithState>(
      builder: (context, state) {
        final hadithText = state is HadithLoaded
            ? state.hadith.text
            : 'Loading daily hadith...';
        final hadithSource = state is HadithLoaded
            ? '— ${state.hadith.book}${state.hadith.reference.isNotEmpty ? ' #${state.hadith.reference}' : ''}'
            : '';

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: const Border(
              left: BorderSide(color: AppColors.primary, width: 4),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withValues(alpha: 0.06),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.format_quote, color: AppColors.primary, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'HADITH OF THE DAY',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '"$hadithText"',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade800,
                  height: 1.6,
                ),
              ),
              if (state is HadithLoaded) ...[
                const SizedBox(height: 8),
                Text(
                  hadithSource,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary.withValues(alpha: 0.5),
                  ),
                ),
              ],
              if (state is HadithError) ...[
                const SizedBox(height: 8),
                Text(
                  state.message,
                  style: TextStyle(fontSize: 11, color: Colors.red.shade400),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildIbadahChecklist() {
    return BlocBuilder<IbadahBloc, IbadahState>(
      builder: (context, state) {
        final items = state is IbadahLoaded ? state.checklist.items : {};

        return ClayCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Daily Ibadah Checklist',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...items.entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: Checkbox(
                            value: entry.value,
                            onChanged: (_) {
                              context.read<IbadahBloc>().add(
                                ToggleIbadahItemRequested(entry.key),
                              );
                            },
                            activeColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          entry.key,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuranCard(BuildContext context) {
    return BlocBuilder<QuranBloc, QuranState>(
      builder: (context, state) {
        final progress = state is QuranLoaded ? state.progress : null;
        final progressValue = progress?.overallProgress ?? 0.0;
        final juzLabel = progress != null
            ? 'Juz ${progress.currentJuz} of 30'
            : 'Loading...';

        return ClayCard(
          onTap: () => context.go('/quran'),
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.secondary.withValues(alpha: 0.1),
                    ),
                    child: const Icon(
                      Icons.menu_book,
                      color: AppColors.secondary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Quran Progress',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          juzLabel,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textPrimary.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Resume',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: progressValue,
                  backgroundColor: Colors.grey.shade100,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.secondary,
                  ),
                  minHeight: 10,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNearbyMasjids() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            if (_initialMapPosition != null)
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _initialMapPosition!,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                onMapCreated: (GoogleMapController controller) {
                  _mapController.complete(controller);
                },
                onTap: (_) => context.push('/masjid-locator'),
              )
            else
              const Center(child: CircularProgressIndicator()),
            Positioned(
              bottom: 16,
              left: 16,
              child: GestureDetector(
                onTap: () => context.push('/masjid-locator'),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.near_me, color: AppColors.primary, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Nearby Masjids',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerAd() {
    final ad = _bannerAd;
    if (ad == null) return const SizedBox.shrink();
    return Center(
      child: SizedBox(
        width: ad.size.width.toDouble(),
        height: ad.size.height.toDouble(),
        child: AdWidget(ad: ad),
      ),
    );
  }

  _NextPrayer? _resolveNextPrayer(List<PrayerTime> times) {
    if (times.isEmpty) return null;

    final now = DateTime.now();
    final sorted = List<PrayerTime>.from(times)
      ..sort((a, b) => _toMinutes(a.time).compareTo(_toMinutes(b.time)));

    for (final prayer in sorted) {
      final prayerTime = _toDateTimeToday(prayer.time);
      if (prayerTime != null && !prayerTime.isBefore(now)) {
        return _NextPrayer(name: prayer.name, time: prayerTime);
      }
    }

    final first = sorted.first;
    final firstTime = _toDateTimeToday(first.time);
    if (firstTime == null) return null;
    return _NextPrayer(
      name: first.name,
      time: firstTime.add(const Duration(days: 1)),
    );
  }

  DateTime? _toDateTimeToday(String time) {
    final parts = time.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  int _toMinutes(String time) {
    final parts = time.split(':');
    if (parts.length != 2) return 0;
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;
    return hour * 60 + minute;
  }

  String _formatCountdown(DateTime target) {
    final now = DateTime.now();
    var diff = target.difference(now);
    if (diff.isNegative) diff = Duration.zero;
    final hours = diff.inHours;
    final minutes = diff.inMinutes.remainder(60);
    if (hours == 0) return '${minutes}m';
    return '${hours}h ${minutes}m';
  }
}

class _NextPrayer {
  final String name;
  final DateTime time;

  const _NextPrayer({required this.name, required this.time});
}
