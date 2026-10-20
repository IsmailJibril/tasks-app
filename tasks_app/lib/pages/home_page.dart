import 'package:flutter/material.dart';

import '../models/task_item.dart';
import '../widgets/progress_card.dart';
import '../widgets/tasks_section.dart';

class HomePage extends StatefulWidget {
  final VoidCallback? onViewAll;

  const HomePage({super.key, this.onViewAll});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<TaskItem> _tasks = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isBefore(DateTime a, DateTime b) =>
      a.year < b.year ||
      (a.year == b.year && a.month < b.month) ||
      (a.year == b.year && a.month == b.month && a.day < b.day);

  void _addTask() {
    DateTime selectedDate = DateTime.now();
    bool isImportant = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('New Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _controller,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'What do you need to do?',
                ),
              ),
              const SizedBox(height: 12),
              // Date picker - today and future only
              Row(
                children: [
                  const Icon(Icons.calendar_month_outlined, size: 20),
                  const SizedBox(width: 8),
                  Text(_formatShort(selectedDate)),
                  const Spacer(),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: ctx,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setDialogState(() => selectedDate = picked);
                      }
                    },
                    child: const Text('Change'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Importance toggle
              Row(
                children: [
                  Icon(
                    Icons.star_rounded,
                    size: 20,
                    color: isImportant
                        ? Colors.amber.shade700
                        : Theme.of(ctx).colorScheme.outline,
                  ),
                  const SizedBox(width: 8),
                  const Text('Mark as important'),
                  const Spacer(),
                  Switch(
                    value: isImportant,
                    onChanged: (v) => setDialogState(() => isImportant = v),
                  ),
                ],
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
                final text = _controller.text.trim();
                if (text.isNotEmpty) {
                  setState(() {
                    _tasks.add(TaskItem(
                      title: text,
                      dueDate: selectedDate,
                      isImportant: isImportant,
                    ));
                  });
                  _controller.clear();
                }
                Navigator.pop(ctx);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleTask(TaskItem task) {
    setState(() {
      task.isDone = !task.isDone;
    });
  }

  void _deleteTask(TaskItem task) {
    setState(() {
      _tasks.remove(task);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));

    final todayTasks =
        _tasks.where((t) => _isSameDay(t.dueDate, now)).toList();
    final tomorrowTasks =
        _tasks.where((t) => _isSameDay(t.dueDate, tomorrow)).toList();
    final overdueTasks = _tasks
        .where((t) => !t.isDone && _isBefore(t.dueDate, now))
        .toList();

    final doneCount = todayTasks.where((t) => t.isDone).length;
    final total = todayTasks.length;
    final progress = total == 0 ? 0.0 : doneCount / total;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                _formatDate(now),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Progress Card
            ProgressCard(
              doneCount: doneCount,
              total: total,
              progress: progress,
            ),

            const SizedBox(height: 16),

            // Overdue Tasks - only shown if there are overdue tasks
            if (overdueTasks.isNotEmpty) ...[
              TasksSection(
                title: 'Overdue Tasks',
                icon: Icons.warning_rounded,
                tasks: overdueTasks,
                onToggle: _toggleTask,
                onDelete: _deleteTask,
                accentColor: Colors.red.shade400,
                height: 180,
                emptyMessage: 'No overdue tasks',
                onViewAll: widget.onViewAll,
              ),
              const SizedBox(height: 24),
            ],

            // Today's Tasks
            TasksSection(
              title: "Today's Tasks",
              icon: Icons.today_rounded,
              tasks: todayTasks,
              onToggle: _toggleTask,
              onDelete: _deleteTask,
              height: 280,
              onViewAll: widget.onViewAll,
            ),

            const SizedBox(height: 24),

            // Tomorrow's Tasks
            TasksSection(
              title: "Tomorrow's Tasks",
              icon: Icons.event_rounded,
              tasks: tomorrowTasks,
              onToggle: _toggleTask,
              onDelete: _deleteTask,
              height: 250,
              onViewAll: widget.onViewAll,
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${days[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }

  String _formatShort(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
