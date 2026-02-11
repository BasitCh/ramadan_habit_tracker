import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ramadan_habit_tracker/features/habits/presentation/bloc/habit_bloc.dart';
import 'package:ramadan_habit_tracker/features/habits/presentation/pages/add_habit_page.dart';
import 'package:ramadan_habit_tracker/features/habits/presentation/widgets/habit_tile.dart';

class HabitsPage extends StatelessWidget {
  const HabitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Habits')),
      body: BlocBuilder<HabitBloc, HabitState>(
        builder: (context, state) {
          if (state is HabitLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is HabitError) {
            return Center(child: Text(state.message));
          }
          if (state is HabitLoaded) {
            if (state.habits.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.checklist, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No habits yet',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tap + to add your first habit',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.habits.length,
              itemBuilder: (context, index) {
                final habit = state.habits[index];
                final isCompleted = state.todayLogs.any(
                  (log) => log.habitId == habit.id && log.completed,
                );
                return HabitTile(
                  habit: habit,
                  isCompleted: isCompleted,
                  onToggle: () {
                    context.read<HabitBloc>().add(
                          ToggleHabitRequested(
                            habitId: habit.id,
                            date: DateTime.now(),
                          ),
                        );
                  },
                  onDelete: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Delete Habit'),
                        content: Text('Delete "${habit.name}"?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              context
                                  .read<HabitBloc>()
                                  .add(DeleteHabitRequested(habit.id));
                              Navigator.pop(ctx);
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddHabitPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
