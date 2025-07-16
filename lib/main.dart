import 'package:flutter/material.dart';
import 'package:todo_app_flutter/bloc/task_event.dart';
import 'package:todo_app_flutter/screens/login_screen.dart';
import 'package:todo_app_flutter/screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_task_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/task_bloc.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/auth_event.dart';
import 'bloc/auth_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyTodoApp());
}

class MyTodoApp extends StatelessWidget {
  const MyTodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc()..add(AppStarted()),
        ),
        BlocProvider<TaskBloc>(create: (context) => TaskBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal,
            brightness: Brightness.dark,
          ),
        ),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              context.read<TaskBloc>().add(LoadTasks(state.token));
              return HomeScreen();
            } else if (state is AuthUnauthenticated) {
              return LoginScreen();
            }
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          },
        ),
        routes: {
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/add-task': (context) => AddTaskScreen(),
        },
      ),
    );
  }
}
