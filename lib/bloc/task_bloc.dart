import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_flutter/models/task.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(const TaskState()) {
    on<ToggleTaskStatus>((event, emit) {
      final updatedTasks = state.tasks.map((task) {
        if (task.id == event.id) {
          return task.copyWith(isDone: event.isDone ?? false);
        }
        return task;
      }).toList();

      emit(TaskState(tasks: updatedTasks));
    });
    on<AddTask>((event, emit) {
      final updatedTasks = List<Task>.from(state.tasks)
        ..add(
          Task(
            id: DateTime.now().toString(),
            title: event.title,
            isDone: false,
          ),
        );
      emit(TaskState(tasks: updatedTasks));
    });
    on<DeleteTask>((event, emit) {
      final updatedTasks = state.tasks
          .where((task) => task.id != event.id)
          .toList();
      emit(TaskState(tasks: updatedTasks));
    });
  }
}
