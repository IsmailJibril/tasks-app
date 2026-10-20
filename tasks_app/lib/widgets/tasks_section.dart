import 'package:flutter/material.dart';

import '../models/task_item.dart';
import 'task_card.dart';
import 'empty_state.dart';

class TasksSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<TaskItem> tasks;
  final void Function(TaskItem task) onToggle;
  final void Function(TaskItem task) onDelete;
  final double height;
  final Color? accentColor;
  final VoidCallback? onViewAll;
  final String emptyMessage;

  const TasksSection({
    super.key,
    required this.title,
    required this.icon,
    required this.tasks,
    required this.onToggle,
    required this.onDelete,
    this.height = 250,
    this.accentColor,
    this.onViewAll,
    this.emptyMessage = 'Nothing here yet',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = accentColor ?? theme.colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          children: [
            Icon(icon, size: 20, color: accent),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${tasks.length}',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (onViewAll != null) ...[
              const SizedBox(width: 4),
              TextButton(
                onPressed: onViewAll,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'View all',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),

        const SizedBox(height: 12),

        // Tasks area - fixed height, scrollable inside
        SizedBox(
          width: double.infinity,
          height: height,
          child: tasks.isEmpty
              ? EmptyState(message: emptyMessage)
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      for (final task in tasks)
                        TaskCard(
                          task: task,
                          onToggle: () => onToggle(task),
                          onDelete: () => onDelete(task),
                        ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
