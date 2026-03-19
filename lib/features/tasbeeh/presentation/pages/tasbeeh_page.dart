import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ramadan_habit_tracker/app/theme/app_colors.dart';
import 'package:ramadan_habit_tracker/features/tasbeeh/presentation/bloc/tasbeeh_bloc.dart';

class TasbeehPage extends StatelessWidget {
  const TasbeehPage({super.key});

  void _showSetLimitDialog(BuildContext context, int currentLimit) {
    final controller = TextEditingController(text: '$currentLimit');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        // resizeToAvoidBottomInset: false on the Scaffold prevents the page
        // from overflowing; the dialog handles its own keyboard inset.
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        title: const Text('Set Tasbeeh Limit'),
        content: SingleChildScrollView(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'e.g. 33, 99, 100',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final val = int.tryParse(controller.text);
              if (val != null && val > 0) {
                context.read<TasbeehBloc>().add(TasbeehLimitSetRequested(val));
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // Prevent the scaffold from shrinking when the dialog's keyboard appears,
      // which was causing bottom overflow on the main page content.
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Tasbeeh Counter',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
        actions: [
          BlocBuilder<TasbeehBloc, TasbeehState>(
            buildWhen: (prev, curr) => prev.limit != curr.limit,
            builder: (context, state) => IconButton(
              icon: const Icon(Icons.tune, color: AppColors.textPrimary),
              tooltip: 'Set Limit',
              onPressed: () => _showSetLimitDialog(context, state.limit),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.textPrimary),
            tooltip: 'Reset',
            onPressed: () {
              HapticFeedback.heavyImpact();
              context.read<TasbeehBloc>().add(const TasbeehResetRequested());
            },
          ),
        ],
      ),
      body: BlocConsumer<TasbeehBloc, TasbeehState>(
        // Listen for cycle completion to trigger medium haptic feedback
        listenWhen: (prev, curr) => curr.cycle > prev.cycle,
        listener: (context, state) => HapticFeedback.mediumImpact(),
        builder: (context, state) {
          final progress =
              state.limit > 0 ? (state.count % state.limit) / state.limit : 0.0;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Display card
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${state.count}',
                        style: const TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontFamily: 'Courier',
                        ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                          backgroundColor: AppColors.primaryLight,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Cycle: ${state.cycle}',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Limit: ${state.limit}',
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
                const SizedBox(height: 60),

                // 3D Tap Button
                GestureDetector(
                  onTapDown: (_) {
                    context
                        .read<TasbeehBloc>()
                        .add(const TasbeehPressChanged(true));
                  },
                  onTapUp: (_) {
                    context
                        .read<TasbeehBloc>()
                        .add(const TasbeehPressChanged(false));
                    HapticFeedback.lightImpact();
                    context
                        .read<TasbeehBloc>()
                        .add(const TasbeehIncrementRequested());
                  },
                  onTapCancel: () {
                    context
                        .read<TasbeehBloc>()
                        .add(const TasbeehPressChanged(false));
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: state.isPressed
                            ? [AppColors.primary, AppColors.primary]
                            : [AppColors.primaryLight, AppColors.primary],
                      ),
                      boxShadow: state.isPressed
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                              const BoxShadow(
                                color: Colors.white,
                                blurRadius: 20,
                                offset: Offset(-5, -5),
                              ),
                            ],
                    ),
                    child: Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                            width: 2,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.fingerprint,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
