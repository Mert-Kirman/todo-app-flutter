abstract class TaskEvent {}

class LoadTasks extends TaskEvent {}

class ToggleTaskStatus extends TaskEvent {
  final String id;
  final bool? isDone;
  ToggleTaskStatus(this.id, this.isDone);
}

class AddTask extends TaskEvent {
  final String title;
  AddTask(this.title);
}

class DeleteTask extends TaskEvent {
  final String id;
  DeleteTask(this.id);
}
