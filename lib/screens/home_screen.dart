import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_flutter/bloc/auth_bloc.dart';
import 'package:todo_app_flutter/bloc/auth_event.dart';
import 'package:todo_app_flutter/bloc/task_bloc.dart';
import 'package:todo_app_flutter/bloc/task_event.dart';
import 'package:todo_app_flutter/bloc/task_state.dart';
import 'package:todo_app_flutter/models/task.dart';
import 'package:todo_app_flutter/services/auth_storage.dart';
import '../widgets/task_tile.dart';

enum TaskSortType { createdAt, dueDate, priority, title }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? currentCategoryFilter; // null means "all categories"
  TaskSortType currentSortType = TaskSortType.createdAt;

  List<Task> _getFilteredTasks(List<Task> tasks, String? category) {
    if (category == null || category.isEmpty) return tasks;
    return tasks
        .where((task) => task.category?.toLowerCase() == category)
        .toList();
  }

  List<Task> _getSortedTasks(List<Task> tasks, TaskSortType sortType) {
    final sorted = List<Task>.from(tasks);
    switch (sortType) {
      case TaskSortType.createdAt:
        sorted.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case TaskSortType.dueDate:
        sorted.sort((a, b) {
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        });
        break;
      case TaskSortType.priority:
        sorted.sort((a, b) => b.priority.compareTo(a.priority));
        break;
      case TaskSortType.title:
        sorted.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
        break;
    }
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  // Get unique categories from tasks
                  final categories = context
                      .read<TaskBloc>()
                      .state
                      .tasks
                      .map((t) => t.category?.toLowerCase())
                      .where((c) => c != null && c.isNotEmpty)
                      .toSet()
                      .toList();
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text('All Categories'),
                        tileColor: currentCategoryFilter == null
                            ? Colors.teal
                            : null,
                        onTap: () {
                          setState(() {
                            currentCategoryFilter = null; // Reset filter
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                      ...categories.map(
                        (category) => ListTile(
                          title: Text(category!),
                          tileColor: currentCategoryFilter == category
                              ? Colors.teal
                              : null,
                          onTap: () {
                            setState(() {
                              currentCategoryFilter = category; // Set filter
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: TaskSortType.values.map((sortType) {
                      return ListTile(
                        title: Text(sortType.toString().split('.').last),
                        // Highlight the currently selected sort type
                        tileColor: currentSortType == sortType
                            ? Colors.teal
                            : null,
                        trailing: currentSortType == sortType
                            ? Icon(Icons.check)
                            : null,
                        onTap: () {
                          setState(() {
                            currentSortType = sortType;
                          });
                          Navigator.of(context).pop();
                        },
                      );
                    }).toList(),
                  );
                },
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              context.read<AuthBloc>().add(LoggedOut());
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
          final filteredTasks = _getFilteredTasks(tasks, currentCategoryFilter);
          final sortedTasks = _getSortedTasks(filteredTasks, currentSortType);
          return ListView.builder(
            itemCount: filteredTasks.length,
            itemBuilder: (ctx, index) {
              final task = sortedTasks[index];
              return TaskTile(
                task: task,
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
