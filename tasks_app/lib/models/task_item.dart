class TaskItem {
  final String id;
  String title;
  bool isDone;

  TaskItem({required this.title, this.isDone = false})
      : id = DateTime.now().millisecondsSinceEpoch.toString();
}
