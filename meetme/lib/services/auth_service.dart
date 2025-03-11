import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final String baseUrl =
      "http://localhost:5000/api/auth"; // ✅ Use localhost for desktop

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  // ✅ Register User
  Future<Map<String, dynamic>> registerUser(
    String name,
    String email,
    String password,
    String role,
    String department,
    String officeHours,
    String bio,
  ) async {
    try {
      final Map<String, dynamic> requestBody = {
        "name": name.trim(),
        "email": email.trim(),
        "password": password.trim(),
        "role": role,
        if (role == "professor") ...{
          "department": department.trim(),
          "officeHours": officeHours.trim(),
          "bio": bio.trim(),
        },
      };

      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return {
          "error":
              jsonDecode(response.body)["error"] ??
              "Failed to register. Check input fields.",
        };
      }
    } catch (e) {
      return {
        "error": "Failed to connect to the server. Ensure backend is running.",
      };
    }
  }

  // ✅ Login User
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email.trim(), "password": password.trim()}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await storage.write(key: "token", value: data['token']);
        await storage.write(key: "user", value: jsonEncode(data['user']));
        return data;
      } else {
        return {
          "error":
              jsonDecode(response.body)["error"] ??
              "Failed to login. Check your email and password.",
        };
      }
    } catch (e) {
      return {
        "error": "Failed to connect to the server. Ensure backend is running.",
      };
    }
  }

  // ✅ Logout User (Remove token from secure storage)
  Future<void> logoutUser() async {
    try {
      await storage.delete(key: "token");
      await storage.delete(key: "user");
      print("✅ User logged out.");
    } catch (e) {
      print("❌ Logout Error: $e");
    }
  }
}