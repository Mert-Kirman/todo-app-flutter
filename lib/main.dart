import 'package:flutter/material.dart';
import 'package:todo_app_flutter/bloc/task_event.dart';
import 'package:todo_app_flutter/screens/login_screen.dart';
import 'package:todo_app_flutter/screens/register_screen.dart';
import 'package:todo_app_flutter/services/auth_storage.dart';
import 'screens/home_screen.dart';
import 'screens/add_task_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/task_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final token = await AuthStorage.getToken();
  runApp(
    MyTodoApp(initialRoute: token == null ? '/login' : '/', token: token ?? ''),
  );
}

class MyTodoApp extends StatelessWidget {
  final String initialRoute;
  final String token;
  const MyTodoApp({required this.initialRoute, required this.token, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final taskBloc = TaskBloc();
        if (token.isNotEmpty) {
          taskBloc.add(LoadTasks(token));
        }
        return taskBloc;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal,
            brightness: Brightness.dark,
          ),
        ),
        initialRoute: initialRoute,
        routes: {
          '/': (ctx) => HomeScreen(),
          '/login': (ctx) => LoginScreen(),
          '/register': (ctx) => RegisterScreen(),
          '/add-task': (ctx) => AddTaskScreen(),
        },
      ),
    );
  }
}
