import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000";

  static const String _tokenKey = 'access_token';
  static const String _emailKey = 'user_email';
  static const String _roleKey = 'user_role';

  //=========================== ACCOUNT ===========================
  static Future<void> createAccount(String email, String username, String password, String role) async {
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (email.isEmpty || !emailRegex.hasMatch(email)) {
      throw Exception('Invalid email format');
    }
    if (username.isEmpty) throw Exception('Username is required');
    if (password.isEmpty) throw Exception('Password is required');

    final response = await http.post(
      Uri.parse('$baseUrl/accounts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "email": email,
        "username": username,
        "password": password,
        "role": role,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Account creation failed');
    }
  }

  static Future<void> login(String email, String password) async {
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (email.isEmpty || !emailRegex.hasMatch(email)) {
      throw Exception('Invalid email format');
    }
    if (password.isEmpty) throw Exception('Password is required');

    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, data['access_token']);
      await prefs.setString(_emailKey, email);
      await prefs.setString(_roleKey, data['role']);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Login failed');
    }
  }

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_roleKey);
  }

  //=========================== CLASSES ===========================
  static Future<void> createClass({
    required String courseName,
    required String professorName,
    required String courseDescription,
  }) async {
    final token = await _getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/classes'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'course_name': courseName,
        'professor_name': professorName,
        'course_description': courseDescription,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create class: ${response.body}');
    }
  }

  static Future<List<Map<String, dynamic>>> getClasses() async {
    final response = await http.get(Uri.parse('$baseUrl/classes'));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch classes: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> getClassByCode(String courseCode) async {
    final response = await http.get(Uri.parse('$baseUrl/classes/$courseCode'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch class: ${response.body}');
    }
  }

  static Future<void> deleteClass(String courseCode) async {
    final token = await _getToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/classes/$courseCode'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete class: ${response.body}');
    }
  }

  static Future<List<Map<String, dynamic>>> getMyClasses() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/my_classes'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch enrolled classes: ${response.body}');
    }
  }

  //=========================== APPOINTMENTS ===========================
  static Future<void> createAppointment({
    required String studentName,
    required String studentEmail,
    required String courseCode,
    required String professorName,
    required DateTime appointmentDate,
  }) async {
    final token = await _getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/appointments'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'student_name': studentName,
        'student_email': studentEmail,
        'course_code': courseCode,
        'professor_name': professorName,
        'appointment_date': appointmentDate.toIso8601String(),
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create appointment: ${response.body}');
    }
  }

  static Future<List<Map<String, dynamic>>> getAppointments() async {
    final response = await http.get(Uri.parse('$baseUrl/appointments'));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch appointments: ${response.body}');
    }
  }

  static Future<void> deleteAppointment(String appointmentId) async {
    final token = await _getToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/appointments/$appointmentId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete appointment: ${response.body}');
    }
  }
}
