import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthApiService {
  final String baseUrl = 'http://localhost:8000';

  Future<String> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/login'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'username': username, 'password': password},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['access_token'];
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  Future<void> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Registration failed: ${response.body}');
    }
  }
}
