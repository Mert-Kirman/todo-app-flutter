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
  runApp(MyTodoApp(isLoggedIn: token != null, token: token ?? ''));
}

class MyTodoApp extends StatelessWidget {
  final bool isLoggedIn;
  final String token;
  const MyTodoApp({required this.isLoggedIn, required this.token, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final taskBloc = TaskBloc();
        if (isLoggedIn) {
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
        home: isLoggedIn ? HomeScreen() : LoginScreen(),
        onGenerateRoute: (settings) {
          // any manual navigation uses Navigator.pushNamed
          Widget page;
          switch (settings.name) {
            case '/register':
              page = RegisterScreen();
              break;
            case '/add-task':
              page = AddTaskScreen();
              break;
            case '/': // user tried to navigate to Home manually
              page = isLoggedIn ? HomeScreen() : LoginScreen();
              break;
            default:
              page = isLoggedIn ? HomeScreen() : LoginScreen();
          }
          return MaterialPageRoute(builder: (_) => page);
        },
      ),
    );
  }
}
