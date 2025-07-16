import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final Function(bool?) onChanged;
  final Function() onDelete;

  const TaskTile({
    super.key,
    required this.task,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (task.description != null && task.description!.isNotEmpty)
            Text('Description: ${task.description}'),
          Text(
            'Created at: ${task.createdAt.toLocal().year}-${task.createdAt.toLocal().month}-${task.createdAt.toLocal().day}',
          ),
          if (task.dueDate != null)
            Text(
              'Due date: ${task.dueDate!.toLocal().year}-${task.dueDate!.toLocal().month}-${task.dueDate!.toLocal().day}',
            ),
          Text('Priority: ${task.priority}'),
          if (task.category != null && task.category!.isNotEmpty)
            Text('Category: ${task.category}'),
        ],
      ),
      leading: Checkbox(value: task.completed, onChanged: onChanged),
      trailing: IconButton(icon: Icon(Icons.delete), onPressed: onDelete),
    );
  }
}
