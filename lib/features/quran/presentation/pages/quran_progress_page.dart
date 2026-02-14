import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ramadan_habit_tracker/app/theme/app_colors.dart';
import 'package:ramadan_habit_tracker/core/presentation/widgets/clay_card.dart';
import 'package:ramadan_habit_tracker/features/quran/presentation/bloc/quran_bloc.dart';

class QuranProgressPage extends StatefulWidget {
  const QuranProgressPage({super.key});

  @override
  State<QuranProgressPage> createState() => _QuranProgressPageState();
}

class _QuranProgressPageState extends State<QuranProgressPage> {
  late final TextEditingController _customPagesController;

  @override
  void initState() {
    super.initState();
    _customPagesController = TextEditingController();
    context.read<QuranBloc>().add(const LoadQuranOverviewRequested());
  }

  @override
  void dispose() {
    _customPagesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<QuranBloc, QuranState>(
          builder: (context, state) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: () {
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
              }(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, QuranLoaded state) {
    final progress = state.progress;
    final surahList = state.surahList ?? [];

    return RefreshIndicator(
      onRefresh: () async {
        context.read<QuranBloc>().add(const LoadQuranOverviewRequested());
      },
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 24),
          // Header
          Row(
            children: [
              const Text(
                'Quran Progress',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => _confirmReset(context),
                icon: const Icon(Icons.refresh),
                tooltip: 'Reset Progress',
              ),
            ],
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
                      TweenAnimationBuilder<double>(
                        tween: Tween(
                          begin: 0,
                          end: progress?.overallProgress ?? 0.0,
                        ),
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, _) {
                          return SizedBox(
                            width: 160,
                            height: 160,
                            child: CircularProgressIndicator(
                              value: value,
                              strokeWidth: 12,
                              backgroundColor: AppColors.primaryLight,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.primary,
                              ),
                              strokeCap: StrokeCap.round,
                            ),
                          );
                        },
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Juz ${progress?.currentJuz ?? 1}',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'of 30',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
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
                    _buildStat(
                      'Pages',
                      '${progress?.currentPage ?? 0}',
                      '/604',
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: AppColors.primaryLight,
                    ),
                    _buildStat(
                      'Today',
                      '${progress?.pagesReadToday ?? 0}',
                      'pages',
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: AppColors.primaryLight,
                    ),
                    _buildStat(
                      'Progress',
                      ((progress?.overallProgress ?? 0.0) * 100)
                          .toStringAsFixed(1),
                      '%',
                    ),
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
              spacing: 10,
              children: [
                Expanded(
                  child: TextField(
                    controller: _customPagesController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Enter pages to add...',
                      border: InputBorder.none,
                      filled: false,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final text = _customPagesController.text;
                    if (text.isNotEmpty) {
                      final pages = int.tryParse(text);
                      if (pages != null && pages > 0) {
                        context.read<QuranBloc>().add(
                          UpdatePagesReadRequested(pages),
                        );
                        _customPagesController.clear();
                        FocusScope.of(context).unfocus();
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
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
                const Text(
                  'Overall Progress',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(
                      begin: 0,
                      end: progress?.overallProgress ?? 0.0,
                    ),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, _) {
                      return LinearProgressIndicator(
                        value: value,
                        minHeight: 12,
                        backgroundColor: AppColors.primaryLight,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${progress?.currentPage ?? 0} of 604 pages completed',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Surah Library',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...surahList.map(
            (surah) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ClayCard(
                onTap: () => context.push('/quran/surah/${surah.number}'),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          surah.number.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            surah.englishName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${surah.englishNameTranslation} • ${surah.numberOfAyahs} ayahs',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      surah.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, String suffix) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              suffix,
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
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
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: Center(
            child: Text(
              '+$pages',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _confirmReset(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Progress'),
        content: const Text(
          'Are you sure you want to reset your Quran reading progress? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<QuranBloc>().add(
                const ResetQuranProgressRequested(),
              );
              Navigator.pop(context);
            },
            child: const Text('Reset', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
