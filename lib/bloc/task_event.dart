abstract class TaskEvent {}

class LoadTasks extends TaskEvent {}

class ToggleTaskStatus extends TaskEvent {
  final int id;
  final bool? completed;
  ToggleTaskStatus(this.id, this.completed);
}

class AddTask extends TaskEvent {
  final String title;
  final String? description;
  final bool? completed;
  final DateTime? dueDate;
  final int? priority;
  final String? category;
  AddTask(
    this.title, {
    this.description,
    this.completed,
    this.dueDate,
    this.priority,
    this.category,
  });
}

class DeleteTask extends TaskEvent {
  final int id;
  DeleteTask(this.id);
}
