import 'package:flutter/material.dart';
import 'package:payouts_platform/data/models/task_model.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onTap;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
  });

  String _formatDeadline(DateTime date) {
    const months = [
      '', 'янв.', 'февр.', 'мар.', 'апр.', 'мая', 'июн.',
      'июл.', 'авг.', 'сент.', 'окт.', 'нояб.', 'дек.',
    ];
    return 'до ${date.day} ${months[date.month]} ${date.year} г.';
  }

  String _formatBudget(double budget) {
    final parts = budget.toStringAsFixed(0).split('');
    final result = StringBuffer();
    for (var i = 0; i < parts.length; i++) {
      if (i > 0 && (parts.length - i) % 3 == 0) result.write('\u00A0');
      result.write(parts[i]);
    }
    return '${result.toString()} ₸';
  }

  @override
  Widget build(BuildContext context) {
    final status = task.status;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заменили Row на Wrap для защиты от ошибки RenderFlex Overflow
            Wrap(
              spacing: 8,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: status.backgroundColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    status.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: status.textColor,
                    ),
                  ),
                ),
                
                if (task.deadline != null)
                  Text(
                    _formatDeadline(task.deadline!),
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 10),

            Text(
              task.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),

            const SizedBox(height: 4),

            if (task.description.isNotEmpty)
              Text(
                task.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                  height: 1.4,
                ),
              ),

            const SizedBox(height: 10),

            Text(
              _formatBudget(task.budget),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF16A34A), 
              ),
            ),
          ],
        ),
      ),
    );
  }
}