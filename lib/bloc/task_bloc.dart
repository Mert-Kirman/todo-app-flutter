import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_flutter/models/task.dart';
import 'package:todo_app_flutter/services/todo_api_service.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TodoApiService apiService = TodoApiService();

  TaskBloc() : super(const TaskState()) {
    on<LoadTasks>((event, emit) async {
      try {
        final todos = await apiService.fetchTodos(event.token);
        emit(TaskState(tasks: todos));
      } catch (e) {
        emit(TaskState(tasks: [], error: e.toString()));
      }
    });

    on<ToggleTaskStatus>((event, emit) async {
      try {
        final updatedTasks = state.tasks.map((task) {
          if (task.id == event.id) {
            return task.copyWith(completed: event.completed ?? false);
          }
          return task;
        }).toList();

        final updatedTask = updatedTasks.firstWhere(
          (task) => task.id == event.id,
        );

        // Update the task status on the server
        await apiService.updateTodo(updatedTask, event.token);

        // Update state
        emit(TaskState(tasks: updatedTasks));
      } catch (e) {
        emit(TaskState(tasks: state.tasks, error: e.toString()));
      }
    });

    on<AddTask>((event, emit) async {
      try {
        final newTask = await apiService.addTodo(
          event.title,
          event.description,
          event.completed,
          event.dueDate,
          event.priority,
          event.category,
          event.token,
        );

        // Update state
        final updatedTasks = List<Task>.from(state.tasks)..add(newTask);
        emit(TaskState(tasks: updatedTasks));
      } catch (e) {
        emit(TaskState(tasks: state.tasks, error: e.toString()));
      }
    });

    on<DeleteTask>((event, emit) async {
      try {
        // Delete the task from the server
        await apiService.deleteTodo(event.id, event.token);

        // Update state
        final updatedTasks = state.tasks
            .where((task) => task.id != event.id)
            .toList();
        emit(TaskState(tasks: updatedTasks));
      } catch (e) {
        emit(TaskState(tasks: state.tasks, error: e.toString()));
      }
    });
  }
}
