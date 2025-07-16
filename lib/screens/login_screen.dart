import 'package:flutter/material.dart';
import 'package:todo_app_flutter/bloc/auth_bloc.dart';
import 'package:todo_app_flutter/bloc/auth_event.dart';
import '../services/auth_api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final token = await AuthApiService().login(
        _usernameController.text,
        _passwordController.text,
      );
      if (!mounted) return;
      context.read<AuthBloc>().add(LoggedIn(token));
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(_error!, style: TextStyle(color: Colors.red)),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _login,
              child: _loading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/register');
                setState(() {
                  _error = null;
                });
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
