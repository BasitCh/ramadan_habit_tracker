import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ramadan_habit_tracker/app/theme/app_colors.dart';
import 'package:ramadan_habit_tracker/core/constants/app_constants.dart';
import 'package:ramadan_habit_tracker/core/presentation/widgets/clay_card.dart';
import 'package:ramadan_habit_tracker/features/adhkar/domain/entities/adhkar.dart';
import 'package:ramadan_habit_tracker/features/adhkar/presentation/bloc/adhkar_bloc.dart';

class AdhkarPage extends StatefulWidget {
  const AdhkarPage({super.key});

  @override
  State<AdhkarPage> createState() => _AdhkarPageState();
}

class _AdhkarPageState extends State<AdhkarPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        final category = _tabController.index == 0
            ? AppConstants.morningAdhkarCategory
            : AppConstants.eveningAdhkarCategory;
        context.read<AdhkarBloc>().add(LoadAdhkarRequested(category));
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_new),
                    style: IconButton.styleFrom(backgroundColor: Colors.white),
                  ),
                  const Expanded(
                    child: Column(
                      children: [
                        Text('Daily Adhkar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Spiritual Consistency', style: TextStyle(fontSize: 10, letterSpacing: 2, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            // Tab bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'Morning'),
                  Tab(text: 'Evening'),
                ],
              ),
            ),

            // Progress indicator
            BlocBuilder<AdhkarBloc, AdhkarState>(
              builder: (context, state) {
                if (state is AdhkarLoaded) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Daily Progress', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                            Text(
                              '${state.completedCount} / ${state.totalCount} Completed',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: state.totalCount > 0 ? state.completedCount / state.totalCount : 0,
                            minHeight: 6,
                            backgroundColor: AppColors.primaryLight,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),

            // Adhkar list
            Expanded(
              child: BlocBuilder<AdhkarBloc, AdhkarState>(
                builder: (context, state) {
                  if (state is AdhkarLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is AdhkarError) {
                    return Center(child: Text(state.message));
                  }
                  if (state is AdhkarLoaded) {
                    if (state.adhkarList.isEmpty) {
                      return const Center(child: Text('No adhkar available'));
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                      itemCount: state.adhkarList.length,
                      itemBuilder: (context, index) {
                        return _buildAdhkarCard(context, state.adhkarList[index]);
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdhkarCard(BuildContext context, Adhkar adhkar) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ClayCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status & repetition badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (adhkar.isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF059669).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('COMPLETED', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF059669))),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'REPEAT ${adhkar.repetitions}X',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary, letterSpacing: 0.5),
                    ),
                  ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.volume_up, size: 18, color: AppColors.textSecondary),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),

            // Completed indicator bar
            if (adhkar.isCompleted)
              Container(
                margin: const EdgeInsets.only(top: 4, bottom: 8),
                height: 3,
                decoration: BoxDecoration(
                  color: const Color(0xFF059669),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

            const SizedBox(height: 12),

            // Arabic text
            Text(
              adhkar.arabic,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 22, height: 2, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),

            // Translation
            Text(
              '"${adhkar.translation}"',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: AppColors.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 16),

            // Counter button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: adhkar.isCompleted
                      ? null
                      : () => context.read<AdhkarBloc>().add(IncrementAdhkarRequested(adhkar.id)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: adhkar.isCompleted ? const Color(0xFF059669) : AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: (adhkar.isCompleted ? const Color(0xFF059669) : AppColors.primary).withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          adhkar.isCompleted ? Icons.check_circle : Icons.touch_app,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${adhkar.currentCount} / ${adhkar.repetitions}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
