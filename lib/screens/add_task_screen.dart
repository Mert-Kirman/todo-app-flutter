import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_flutter/bloc/task_bloc.dart';
import 'package:todo_app_flutter/bloc/task_event.dart';
import 'package:todo_app_flutter/services/auth_storage.dart';

class AddTaskScreen extends StatelessWidget {
  final TextEditingController _taskTitleController = TextEditingController();

  AddTaskScreen({super.key});

  void _addTask(BuildContext context) async {
    final taskText = _taskTitleController.text;
    if (taskText.isNotEmpty) {
      final token = await AuthStorage.getToken();
      context.read<TaskBloc>().add(AddTask(taskText, token ?? ''));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Task')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _taskTitleController,
              decoration: InputDecoration(labelText: 'Task'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _addTask(context),
              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
