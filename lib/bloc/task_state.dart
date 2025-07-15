import '../models/task.dart';

class TaskState {
  final List<Task> tasks;
  final String? error;

  const TaskState({this.tasks = const [], this.error});

  TaskState copyWith({List<Task>? tasks, String? error}) {
    return TaskState(tasks: tasks ?? this.tasks, error: error);
  }
}
