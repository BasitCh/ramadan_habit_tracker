import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ramadan_habit_tracker/app/theme/app_colors.dart';
import 'package:ramadan_habit_tracker/core/constants/app_constants.dart';
import 'package:ramadan_habit_tracker/features/quran/presentation/bloc/quran_bloc.dart';
import 'package:ramadan_habit_tracker/features/quran/presentation/widgets/juz_progress_card.dart';

class QuranProgressPage extends StatelessWidget {
  const QuranProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quran Progress')),
      body: BlocBuilder<QuranBloc, QuranState>(
        builder: (context, state) {
          if (state is QuranLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is QuranError) {
            return Center(child: Text(state.message));
          }
          if (state is QuranLoaded) {
            final progress = state.progress;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                JuzProgressCard(
                  currentJuz: progress.currentJuz,
                  pagesRead: progress.pagesRead,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Current Juz',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: progress.currentJuz > 1
                              ? () => context.read<QuranBloc>().add(
                                    UpdateJuz(progress.currentJuz - 1),
                                  )
                              : null,
                          icon: const Icon(Icons.remove_circle_outline),
                          iconSize: 32,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '${progress.currentJuz}',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          onPressed: progress.currentJuz < AppConstants.totalJuz
                              ? () => context.read<QuranBloc>().add(
                                    UpdateJuz(progress.currentJuz + 1),
                                  )
                              : null,
                          icon: const Icon(Icons.add_circle_outline),
                          iconSize: 32,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Pages Read Today',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: progress.pagesRead > 0
                              ? () => context.read<QuranBloc>().add(
                                    UpdatePagesRead(progress.pagesRead - 1),
                                  )
                              : null,
                          icon: const Icon(Icons.remove_circle_outline),
                          iconSize: 32,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '${progress.pagesRead}',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          onPressed: () => context.read<QuranBloc>().add(
                                UpdatePagesRead(progress.pagesRead + 1),
                              ),
                          icon: const Icon(Icons.add_circle_outline),
                          iconSize: 32,
                        ),
                      ],
                    ),
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
