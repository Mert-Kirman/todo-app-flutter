import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final String title;
  final bool completed;
  final Function(bool?) onChanged;
  final Function() onDelete;

  const TaskTile({
    super.key,
    required this.title,
    required this.completed,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Checkbox(value: completed, onChanged: onChanged),
      trailing: IconButton(icon: Icon(Icons.delete), onPressed: onDelete),
    );
  }
}
