import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ramadan_habit_tracker/app/theme/app_colors.dart';
import 'package:ramadan_habit_tracker/core/presentation/widgets/clay_card.dart';
import 'package:ramadan_habit_tracker/features/quran/presentation/bloc/quran_bloc.dart';

class QuranProgressPage extends StatelessWidget {
  const QuranProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<QuranBloc, QuranState>(
          builder: (context, state) {
            if (state is QuranLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is QuranError) {
              return Center(child: Text(state.message));
            }
            if (state is QuranLoaded) {
              return _buildContent(context, state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, QuranLoaded state) {
    final progress = state.progress;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [
        const SizedBox(height: 24),
        // Header
        const Text(
          'Quran Progress',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 8),
        Text(
          'Track your daily reading',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),

        const SizedBox(height: 32),

        // Main progress card
        ClayCard(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              // Circular progress
              SizedBox(
                width: 160,
                height: 160,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: CircularProgressIndicator(
                        value: progress.overallProgress,
                        strokeWidth: 12,
                        backgroundColor: AppColors.primaryLight,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Juz ${progress.currentJuz}',
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'of 30',
                          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Stats row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStat('Pages', '${progress.currentPage}', '/604'),
                  Container(width: 1, height: 40, color: AppColors.primaryLight),
                  _buildStat('Today', '${progress.pagesReadToday}', 'pages'),
                  Container(width: 1, height: 40, color: AppColors.primaryLight),
                  _buildStat('Progress', '${(progress.overallProgress * 100).toStringAsFixed(1)}', '%'),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Quick add buttons
        const Text(
          'Log Pages Read',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            _buildQuickAddButton(context, 1),
            const SizedBox(width: 12),
            _buildQuickAddButton(context, 5),
            const SizedBox(width: 12),
            _buildQuickAddButton(context, 10),
            const SizedBox(width: 12),
            _buildQuickAddButton(context, 20),
          ],
        ),

        const SizedBox(height: 16),

        // Custom input
        ClayCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter custom pages...',
                    border: InputBorder.none,
                    filled: false,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // TODO: Read from text field
                },
                child: const Text('Add'),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Overall progress bar
        ClayCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Overall Progress', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress.overallProgress,
                  minHeight: 12,
                  backgroundColor: AppColors.primaryLight,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${progress.currentPage} of 604 pages completed',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildStat(String label, String value, String suffix) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(suffix, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildQuickAddButton(BuildContext context, int pages) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          context.read<QuranBloc>().add(UpdatePagesReadRequested(pages));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: Center(
            child: Text(
              '+$pages',
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
          ),
        ),
      ),
    );
  }
}
