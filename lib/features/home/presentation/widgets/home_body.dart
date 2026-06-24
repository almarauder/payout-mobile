import 'package:flutter/material.dart';
import 'package:payouts_platform/data/models/task_model.dart';
import '../widgets/task_card.dart'; 

class HomeBody extends StatelessWidget {
  final bool isLoading;
  final String? error;
  final List<TaskModel> tasks;
  final RefreshCallback onRefresh;
  final ValueChanged<TaskModel>? onTaskTap;

  const HomeBody({
    super.key,
    required this.isLoading,
    required this.error,
    required this.tasks,
    required this.onRefresh,
    this.onTaskTap, 
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && tasks.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            error!,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    
    if (tasks.isEmpty) {
      return const Center(child: Text('Задач нет'));
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: tasks.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final task = tasks[index];
          return TaskCard(
            task: task,
            onTap: () => onTaskTap?.call(task), 
          );
        },
      ),
    );
  }
}