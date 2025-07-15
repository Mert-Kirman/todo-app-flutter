import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_flutter/bloc/task_bloc.dart';
import 'package:todo_app_flutter/bloc/task_event.dart';
import 'package:todo_app_flutter/bloc/task_state.dart';
import 'package:todo_app_flutter/services/auth_storage.dart';
import '../widgets/task_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await AuthStorage.deleteToken();
              if (!context.mounted) return;
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/login', (route) => false);
            },
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state.error != null) {
            return Center(child: Text('Error: ${state.error}'));
          }
          final tasks = state.tasks;
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (ctx, index) {
              final task = tasks[index];
              return TaskTile(
                title: task.title,
                completed: task.completed,
                onChanged: (value) async {
                  final token = await AuthStorage.getToken();
                  if (token == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'You must be logged in to change task status',
                        ),
                      ),
                    );
                    return;
                  }
                  context.read<TaskBloc>().add(
                    ToggleTaskStatus(task.id, value, token),
                  );
                },
                onDelete: () async {
                  final token = await AuthStorage.getToken();
                  if (token == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('You must be logged in to delete a task'),
                      ),
                    );
                    return;
                  }
                  context.read<TaskBloc>().add(DeleteTask(task.id, token));
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/add-task');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
