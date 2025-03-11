import 'package:flutter/material.dart';
import 'package:meetme/screens/loginpage.dart';
import 'package:meetme/services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController officeHoursController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  final AuthService authService = AuthService();
  String selectedRole = "student"; // Default role
  bool isLoading = false; // Loading state

  @override
  void dispose() {
    // ✅ Dispose controllers to prevent memory leaks
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    departmentController.dispose();
    officeHoursController.dispose();
    bioController.dispose();
    super.dispose();
  }

  void register() async {
    if (isLoading) return; // Prevent multiple requests

    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all required fields.")),
      );
      return;
    }

    if (selectedRole == "professor" &&
        (departmentController.text.trim().isEmpty ||
            officeHoursController.text.trim().isEmpty ||
            bioController.text.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all professor details.")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    // ✅ Construct user data
    final Map<String, dynamic> userData = {
      "name": nameController.text.trim(),
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
      "role": selectedRole,
    };

    // ✅ Add professor-specific fields only if selectedRole is "professor"
    if (selectedRole == "professor") {
      userData.addAll({
        "department": departmentController.text.trim(),
        "officeHours": officeHoursController.text.trim(),
        "bio": bioController.text.trim(),
      });
    }

    print("🔍 Sending Sign-Up Request: $userData");

    // ✅ Fetch sign-up response
    final response = await authService.registerUser(
      userData["name"],
      userData["email"],
      userData["password"],
      userData["role"],
      userData.containsKey("department") ? userData["department"] : "",
      userData.containsKey("officeHours") ? userData["officeHours"] : "",
      userData.containsKey("bio") ? userData["bio"] : "",
    );

    setState(() {
      isLoading = false;
    });

    if (response.containsKey("message")) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response["message"])));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response["error"] ?? "Sign-up failed. Please try again.",
          ),
        ),
      );
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
        appBar: AppBar(title: const Text("Sign Up")),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Create an Account",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Full Name"),
              ),
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
              const SizedBox(height: 20),
              const Text("Register as:"),
              DropdownButton<String>(
                value: selectedRole,
                items: const [
                  DropdownMenuItem(value: "student", child: Text("Student")),
                  DropdownMenuItem(
                    value: "professor",
                    child: Text("Professor"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedRole = value!;
                    print(
                      "🔄 Role switched to: $selectedRole",
                    ); // Debugging log
                  });
                },
              ),
              if (selectedRole == "professor") ...[
                TextField(
                  controller: departmentController,
                  decoration: const InputDecoration(labelText: "Department"),
                ),
                TextField(
                  controller: officeHoursController,
                  decoration: const InputDecoration(labelText: "Office Hours"),
                ),
                TextField(
                  controller: bioController,
                  decoration: const InputDecoration(labelText: "Bio"),
                ),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child:
                      isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text("Already have an account? Log in"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}