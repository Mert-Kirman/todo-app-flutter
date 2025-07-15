// Handle all HTTP requests to the backend

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class TodoApiService {
  final String baseUrl = 'http://localhost:8000';

  Future<List<Task>> fetchTodos(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/todos/'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Task.fromMap(e)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }

  Future<Task> addTodo(
    String title,
    String? description,
    bool? completed,
    DateTime? dueDate,
    int? priority,
    String? category,
    String token,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/todos/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'title': title,
        'description':
            description, // Since backend handles it, we can pass null
        'completed': completed,
        'due_date': dueDate?.toIso8601String(),
        'priority': priority,
        'category': category,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Task.fromMap(json.decode(response.body));
    } else {
      throw Exception('Failed to add todo');
    }
  }

  Future<Task> updateTodo(Task task, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/todos/${task.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'title': task.title,
        'description': task.description,
        'completed': task.completed,
        'due_date': task.dueDate?.toIso8601String(),
        'priority': task.priority,
        'category': task.category,
      }),
    );
    if (response.statusCode == 200) {
      return Task.fromMap(json.decode(response.body));
    } else {
      throw Exception('Failed to update todo');
    }
  }

  Future<void> deleteTodo(int id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/todos/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete todo');
    }
  }
}
