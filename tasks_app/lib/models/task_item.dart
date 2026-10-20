class TaskItem {
  final String id;
  String title;
  bool isDone;
  bool isImportant;
  DateTime dueDate;

  TaskItem({
    required this.title,
    this.isDone = false,
    this.isImportant = false,
    DateTime? dueDate,
  })  : dueDate = dueDate ?? DateTime.now(),
        id = DateTime.now().millisecondsSinceEpoch.toString();
}
