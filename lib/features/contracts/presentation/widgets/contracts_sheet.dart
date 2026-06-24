import 'package:flutter/material.dart';
import 'package:payouts_platform/data/models/task_model.dart';

class ContractDetailsSheet extends StatelessWidget {
  final TaskModel task;

  const ContractDetailsSheet({
    super.key,
    required this.task,
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
    
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Статус и Дедлайн
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: status.backgroundColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: status.textColor,
                  ),
                ),
              ),
              if (task.deadline != null)
                Text(
                  _formatDeadline(task.deadline!),
                  style: const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
                ),
            ],
          ),
          const SizedBox(height: 16),
          
          Text(
            task.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 12),
          
          if (task.description.isNotEmpty) ...[
            Text(
              task.description,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
          ],
          
          const Divider(color: Color(0xFFE5E7EB)),
          const SizedBox(height: 12),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Бюджет договора',
                style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
              ),
              Text(
                _formatBudget(task.budget),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF16A34A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}