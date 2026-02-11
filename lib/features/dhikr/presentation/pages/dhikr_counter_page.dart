import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ramadan_habit_tracker/features/dhikr/presentation/bloc/dhikr_bloc.dart';
import 'package:ramadan_habit_tracker/features/dhikr/presentation/widgets/dhikr_counter_widget.dart';

class DhikrCounterPage extends StatelessWidget {
  const DhikrCounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dhikr Counter')),
      body: BlocBuilder<DhikrBloc, DhikrState>(
        builder: (context, state) {
          if (state is DhikrLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is DhikrError) {
            return Center(child: Text(state.message));
          }
          if (state is DhikrLoaded) {
            if (state.dhikrList.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.touch_app, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No dhikr added yet',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: state.dhikrList.length,
              itemBuilder: (context, index) {
                final dhikr = state.dhikrList[index];
                return DhikrCounterWidget(
                  dhikr: dhikr,
                  onIncrement: () {
                    context
                        .read<DhikrBloc>()
                        .add(IncrementDhikrRequested(dhikr.id));
                  },
                  onReset: () {
                    context
                        .read<DhikrBloc>()
                        .add(ResetDhikrRequested(dhikr.id));
                  },
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDhikrDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDhikrDialog(BuildContext context) {
    final nameController = TextEditingController();
    final targetController = TextEditingController(text: '33');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Dhikr'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Dhikr Name',
                hintText: 'e.g., SubhanAllah',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: targetController,
              decoration: const InputDecoration(
                labelText: 'Target Count',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final name = nameController.text.trim();
              final target = int.tryParse(targetController.text) ?? 33;
              if (name.isNotEmpty) {
                context.read<DhikrBloc>().add(
                      AddDhikrRequested(name: name, targetCount: target),
                    );
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
