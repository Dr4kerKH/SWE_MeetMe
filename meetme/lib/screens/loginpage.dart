import 'package:flutter/material.dart';
import 'package:meetme/screens/sign_up.dart';
import 'package:meetme/services/auth_service.dart';
import 'student_homepage.dart'; // Student Homepage
import 'professor_homepage.dart'; // Professor Homepage

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();
  bool isLoading = false;

  @override
  void dispose() {
    // ✅ Properly dispose controllers to prevent memory leaks
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() async {
    if (isLoading) return; // Prevent multiple login attempts

    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    // ✅ Fetch login response (token & user data)
    Map<String, dynamic>? loginResponse = await authService.loginUser(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    setState(() {
      isLoading = false;
    });

    if (loginResponse != null && loginResponse.containsKey("user")) {
      final user = loginResponse["user"];
      final String role =
          user["role"] ?? "student"; // Default to student if missing

      print("🔍 User Role: $role"); // Debugging log

      // ✅ Navigate to the correct page based on role
      if (role == "professor") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfessorHomePage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } else {
      String errorMessage =
          loginResponse?["error"] ??
          "Login failed. Please check your credentials.";
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap:
          () =>
              FocusScope.of(
                context,
              ).unfocus(), // ✅ Dismiss keyboard when tapping outside
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/cover');
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 30),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child:
                      isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            "Login",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
                    ),
                  );
                },
                child: const Text("Don’t have an account? Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}