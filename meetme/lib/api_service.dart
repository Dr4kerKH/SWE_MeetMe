import 'dart:convert';
//import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Change base URL accordingly
  static const String baseUrl = 'http://127.0.0.1:8000'; // Local testing
  // static const String baseUrl = 'http://192.168.x.x:8000'; // Use LAN IP for physical devices
  
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> createAccount(String email, String username, String password, String role) async {
    final response = await http.post(
      Uri.parse('$baseUrl/accounts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "email": email,
        "username": username,
        "password": password,
        "role": role, // "professor" or "student"
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create account: ${response.body}');
    }
  }

  static Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        "username": email,
        "password": password,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['access_token'];
      await saveToken(token); // Store token for future use
      return token;
    } else {
      throw Exception('Failed to log in: ${response.body}');
    }
  }

  static Future<List<Map<String, dynamic>>> getClasses() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/classes'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch classes: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> getClassById(String courseId) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/classes/$courseId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch class: ${response.body}');
    }
  }

  static Future<void> createAppointment({
    required String studentName,
    required String studentEmail,
    required String courseId,
    required String courseName,
    required String professorName,
    required DateTime dateTime,
  }) async {
    final url = Uri.parse('$baseUrl/appointments');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'studentName': studentName,
        'studentEmail': studentEmail,
        'courseId': courseId,
        'courseName': courseName,
        'professorName': professorName,
        'appointment_date': dateTime.toIso8601String(),
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create appointment');
    }
  }

  static Future<List<Map<String, dynamic>>> getAppointments() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/appointments'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch appointments: ${response.body}');
    }
  }

  static Future<void> deleteAppointment(String appointmentId) async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/appointments/$appointmentId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete appointment: ${response.body}');
    }
  }

  static Future<void> deleteClass(String courseId) async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/classes/$courseId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete class: ${response.body}');
    }
  }
}