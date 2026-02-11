import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ramadan_habit_tracker/app/theme/app_colors.dart';
import 'package:ramadan_habit_tracker/core/constants/app_constants.dart';
import 'package:ramadan_habit_tracker/features/prayer/presentation/bloc/prayer_bloc.dart';
import 'package:ramadan_habit_tracker/features/prayer/presentation/widgets/prayer_card.dart';

class PrayerTrackerPage extends StatelessWidget {
  const PrayerTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prayer Tracker')),
      body: BlocBuilder<PrayerBloc, PrayerState>(
        builder: (context, state) {
          if (state is PrayerLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PrayerError) {
            return Center(child: Text(state.message));
          }
          if (state is PrayerLoaded) {
            final log = state.prayerLog;
            final completed = log.completedCount;
            final total = log.totalCount;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  color: AppColors.primary,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          '$completed / $total',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Prayers Completed Today',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Fard Prayers',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                ...AppConstants.prayerNames.map(
                  (name) => PrayerCard(
                    prayerName: name,
                    isCompleted: log.prayers[name] ?? false,
                    onToggle: () {
                      context.read<PrayerBloc>().add(
                            TogglePrayerRequested(
                              prayerName: name,
                              date: DateTime.now(),
                            ),
                          );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Additional Prayers',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                ...AppConstants.additionalPrayers.map(
                  (name) => PrayerCard(
                    prayerName: name,
                    isCompleted: log.prayers[name] ?? false,
                    onToggle: () {
                      context.read<PrayerBloc>().add(
                            TogglePrayerRequested(
                              prayerName: name,
                              date: DateTime.now(),
                            ),
                          );
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
