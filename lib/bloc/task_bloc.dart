import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_flutter/models/task.dart';
import 'task_event.dart';
import 'task_state.dart';
import 'package:localstore/localstore.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final db = Localstore.instance;
  final String collection = 'tasks';

  TaskBloc() : super(const TaskState()) {
    on<LoadTasks>((event, emit) async {
      final items = await db.collection(collection).get(); // Load all tasks
      final tasks = items?.values.map((e) => Task.fromMap(e)).toList() ?? [];
      emit(TaskState(tasks: tasks));
    });

    on<ToggleTaskStatus>((event, emit) async {
      final updatedTasks = state.tasks.map((task) {
        if (task.id == event.id) {
          return task.copyWith(isDone: event.isDone ?? false);
        }
        return task;
      }).toList();

      // Save the updated task to localstore (only one)
      final updatedTask = updatedTasks.firstWhere(
        (task) => task.id == event.id,
      );
      await db
          .collection(collection)
          .doc(updatedTask.id)
          .set(updatedTask.toMap());

      emit(TaskState(tasks: updatedTasks));
    });

    on<AddTask>((event, emit) async {
      // Create the new task
      final newTask = Task(
        id: DateTime.now().toString(),
        title: event.title,
        isDone: false,
      );

      // Save to localstore
      await db.collection(collection).doc(newTask.id).set(newTask.toMap());

      // Update state
      final updatedTasks = List<Task>.from(state.tasks)..add(newTask);
      emit(TaskState(tasks: updatedTasks));
    });

    on<DeleteTask>((event, emit) async {
      // Remove the task from localstore
      await db.collection(collection).doc(event.id).delete();

      // Update state
      final updatedTasks = state.tasks
          .where((task) => task.id != event.id)
          .toList();
      emit(TaskState(tasks: updatedTasks));
    });
  }
}
