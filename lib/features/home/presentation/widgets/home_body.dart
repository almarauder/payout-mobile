import 'package:flutter/material.dart';
import 'package:payouts_platform/data/models/task_model.dart';
import '../widgets/task_card.dart'; 

class HomeBody extends StatelessWidget {
  final bool isLoading;
  final String? error;
  final List<TaskModel> tasks;
  final RefreshCallback onRefresh;

  const HomeBody({
    super.key,
    required this.isLoading,
    required this.error,
    required this.tasks,
    required this.onRefresh,
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
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemCount: tasks.length,
        itemBuilder: (context, index) => TaskCard(task: tasks[index]),
      ),
    );
  }
}