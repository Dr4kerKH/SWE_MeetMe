import 'package:flutter/material.dart';
import 'package:meetme/services/auth_service.dart'; // Update with your actual path

class ProfessorHomePage extends StatefulWidget {
  const ProfessorHomePage({super.key});

  @override
  _ProfessorHomePageState createState() => _ProfessorHomePageState();
}

class _ProfessorHomePageState extends State<ProfessorHomePage> {
  int _selectedIndex = 0;
  final AuthService _authService = AuthService();

  // Placeholder widgets for each navigation item
  static const List<Widget> _widgetOptions = <Widget>[
    // Home: Welcome message and schedule placeholder
    Center(
      child: Text(
        'Welcome, Professor!\nHere is your schedule.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),
    // Profile: Edit profile placeholder
    Center(
      child: Text(
        'Edit Your Profile Here',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),
    // Calendar: Calendar view placeholder
    Center(
      child: Text(
        'Calendar View',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),
    // Settings: Settings placeholder
    Center(
      child: Text(
        'Settings',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),
  ];

  /* void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }*/

  void _onItemTapped(int index) {
    if (index == 3) {
      // Settings Icon tapped
      Navigator.pushNamed(context, '/professor_settings');
    } else if (index == 4) {
      // Logout
      _logout();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Future<void> _logout() async {
    await _authService.logoutUser();
    // Navigate to the login page and remove all previous routes
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Professor Dashboard"),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ), // Added logout here
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: (int index) {
          if (index == 4) {
            _logout(); // Trigger logout when the logout button is tapped
          } else {
            _onItemTapped(index);
          }
        },
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}