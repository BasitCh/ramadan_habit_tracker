import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ramadan_habit_tracker/app/theme/app_colors.dart';
import 'package:ramadan_habit_tracker/core/presentation/widgets/clay_card.dart';
import 'package:ramadan_habit_tracker/features/dua/domain/entities/dua.dart';
import 'package:ramadan_habit_tracker/features/dua/presentation/bloc/dua_bloc.dart';

class DuaOfDayPage extends StatefulWidget {
  const DuaOfDayPage({super.key});

  @override
  State<DuaOfDayPage> createState() => _DuaOfDayPageState();
}

class _DuaOfDayPageState extends State<DuaOfDayPage> {
  @override
  void initState() {
    super.initState();
    context.read<DuaBloc>().add(const LoadDailyDuaRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<DuaBloc, DuaState>(
          builder: (context, state) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: () {
                if (state is DuaLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is DuaError) {
                  return Center(child: Text(state.message));
                }
                if (state is DuaLoaded) {
                  return _buildContent(context, state.dua);
                }
                return const SizedBox.shrink();
              }(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Dua dua) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dua of the Day',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Ramadan 2026',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Main content
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<DuaBloc>().add(const LoadDailyDuaRequested());
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // Dua Card
                  ClayCard(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        // Decorative mosque icon
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary.withValues(alpha: 0.1),
                          ),
                          child: const Icon(
                            Icons.mosque,
                            color: AppColors.primary,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Category badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'DUA OF THE DAY',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Arabic text
                        Text(
                          dua.arabic,
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                            fontSize: 32,
                            height: 1.8,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Divider
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 32,
                              height: 1,
                              color: AppColors.primary.withValues(alpha: 0.2),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.auto_awesome,
                              size: 14,
                              color: AppColors.primary.withValues(alpha: 0.4),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 32,
                              height: 1,
                              color: AppColors.primary.withValues(alpha: 0.2),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Transliteration
                        Text(
                          '"${dua.transliteration}"',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: AppColors.textSecondary,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Translation
                        Text(
                          dua.translation,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            height: 1.6,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Action buttons row
                  Row(
                    children: [
                      Expanded(
                        child: ClayCard(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          onTap: () async {
                            await Clipboard.setData(
                              ClipboardData(text: _formatShareText(dua)),
                            );
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Dua copied to clipboard'),
                              ),
                            );
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.content_copy,
                                size: 18,
                                color: AppColors.textSecondary,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Copy',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ClayCard(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          onTap: () async {
                            await Share.share(_formatShareText(dua));
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.ios_share,
                                size: 18,
                                color: AppColors.textSecondary,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Share',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Reference card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            dua.reference,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),

        // Bottom action button
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: AppColors.primaryLight.withValues(alpha: 0.5),
              ),
            ),
          ),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () {
                context.read<DuaBloc>().add(MarkAsRecitedRequested(dua.id));
              },
              icon: Icon(
                dua.isRecited ? Icons.check_circle : Icons.check_circle_outline,
              ),
              label: Text(dua.isRecited ? 'Recited' : 'Mark as Recited'),
              style: ElevatedButton.styleFrom(
                backgroundColor: dua.isRecited
                    ? AppColors.success
                    : AppColors.primary,
                foregroundColor: dua.isRecited
                    ? const Color(0xFF059669)
                    : AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatShareText(Dua dua) {
    return [
      'Dua of the Day',
      '',
      dua.arabic,
      '',
      dua.transliteration,
      '',
      dua.translation,
      '',
      dua.reference,
    ].join('\n');
  }
}
