import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meetme/screens/loginpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<String> _professorList = [];
  bool _isLoading = true;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    fetchProfessors();
  }

  // 🔹 Fetch professors from API
  Future<void> fetchProfessors() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:5000/api/professors'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _professorList = data.map((prof) => prof['name'].toString()).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load professors: ${response.statusCode}');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Error fetching professors. Please try again.";
      });
    }
  }

  // 🔹 Build the Autocomplete widget for professor search.
  Widget _buildProfessorSearch() {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _errorMessage.isNotEmpty
        ? Center(
          child: Text(_errorMessage, style: const TextStyle(color: Colors.red)),
        )
        : Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            return _professorList.where((String option) {
              return option.toLowerCase().contains(
                textEditingValue.text.toLowerCase(),
              );
            });
          },
          onSelected: (String selection) {
            print('Selected professor: $selection');
          },
          fieldViewBuilder: (
            BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted,
          ) {
            return TextField(
              controller: textEditingController,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: 'Find a professor...',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search, color: Colors.black54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            );
          },
        );
  }

  // 🔹 Quick Action Button Widget
  Widget _quickActionButton(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            child: Icon(icon, color: Colors.black87, size: 26),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // 🔹 Logout function using FlutterSecureStorage
  Future<void> logout(BuildContext context) async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    await storage.delete(key: "token"); // Remove JWT token
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  // 🔹 Build content based on selected bottom nav item.
  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0: // Home
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gradient Background Container with Search and Quick Actions
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.shade100,
                      Colors.red.shade100,
                      Colors.green.shade100,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 Autocomplete for professor search
                    _buildProfessorSearch(),
                    const SizedBox(height: 15),
                    // 🔹 Quick Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _quickActionButton(
                          Icons.calendar_today,
                          "New Appointment",
                          () {
                            Navigator.pushNamed(context, '/professor_list');
                          },
                        ),
                        _quickActionButton(Icons.chat, "Chat", () {
                          Navigator.pushNamed(context, '/chat');
                        }),
                        _quickActionButton(
                          Icons.video_call,
                          "Virtual Meeting",
                          () {
                            Navigator.pushNamed(context, '/virtual_meeting');
                          },
                        ),
                        _quickActionButton(Icons.analytics, "Dashboard", () {
                          Navigator.pushNamed(context, '/dashboard');
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      case 1:
        return const Center(child: Text("Dashboard coming soon..."));
      case 2:
        return const Center(child: Text("Schedule coming soon..."));
      case 3:
        return const Center(child: Text("Chat coming soon..."));
      case 4:
        return const Center(child: Text("Settings coming soon..."));
      case 5:
        return const Center(child: Text("Profile coming soon..."));
      default:
        return const Center(child: Text("Feature coming soon..."));
    }
  }

  // 🔹 Bottom Navigation Bar onTap callback.
  void _onItemTapped(int index) {
    switch (index) {
      case 4: // Settings
        Navigator.pushNamed(context, '/student_settings');
        break;
      case 6: // Logout
        logout(context);
        break;
      default:
        setState(() {
          _selectedIndex = index;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the back button
        title: const Text(
          "Welcome!",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _buildContent(),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black54,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: "Schedule",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Chat"),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: "Logout"),
        ],
      ),
    );
  }
}