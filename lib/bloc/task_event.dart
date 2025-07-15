abstract class TaskEvent {}

class LoadTasks extends TaskEvent {
  final String token;
  LoadTasks(this.token);
}

class ToggleTaskStatus extends TaskEvent {
  final int id;
  final bool? completed;
  final String token;
  ToggleTaskStatus(this.id, this.completed, this.token);
}

class AddTask extends TaskEvent {
  final String title;
  final String? description;
  final bool? completed;
  final DateTime? dueDate;
  final int? priority;
  final String? category;
  final String token;
  AddTask(
    this.title,
    this.token, {
    this.description,
    this.completed,
    this.dueDate,
    this.priority,
    this.category,
  });
}

class DeleteTask extends TaskEvent {
  final int id;
  final String token;
  DeleteTask(this.id, this.token);
}
