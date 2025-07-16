import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_flutter/bloc/task_bloc.dart';
import 'package:todo_app_flutter/bloc/task_event.dart';
import 'package:todo_app_flutter/services/auth_storage.dart';

class AddTaskScreen extends StatelessWidget {
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _taskDescriptionController =
      TextEditingController();
  final TextEditingController _taskCategoryController = TextEditingController();
  final TextEditingController _taskDueDateController = TextEditingController();
  final TextEditingController _taskPriorityController = TextEditingController();

  AddTaskScreen({super.key});

  void _addTask(BuildContext context) async {
    final taskText = _taskTitleController.text;
    if (taskText.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Task title cannot be empty')));
      return;
    }

    final taskDescription = _taskDescriptionController.text;
    final taskCategory = _taskCategoryController.text;
    final taskDueDate = _taskDueDateController.text.isNotEmpty
        ? DateTime.parse(_taskDueDateController.text)
        : null;
    final taskPriority = _taskPriorityController.text.isNotEmpty
        ? int.tryParse(_taskPriorityController.text)
        : null;

    if (taskText.isNotEmpty) {
      final token = await AuthStorage.getToken();
      context.read<TaskBloc>().add(
        AddTask(
          taskText,
          token ?? '',
          description: taskDescription,
          category: taskCategory,
          dueDate: taskDueDate,
          priority: taskPriority,
        ),
      );
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
            TextField(
              controller: _taskDescriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _taskCategoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
            TextField(
              controller: _taskDueDateController,
              decoration: InputDecoration(labelText: 'Due Date (YYYY-MM-DD)'),
            ),
            TextField(
              controller: _taskPriorityController,
              decoration: InputDecoration(labelText: 'Priority (1-5)'),
              keyboardType: TextInputType.number,
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
