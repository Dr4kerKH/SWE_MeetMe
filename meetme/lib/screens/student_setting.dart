import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meetme/screens/theme_provider.dart';

class StudentSettings extends StatelessWidget {
  const StudentSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Student Settings")),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Dark Mode"),
            secondary: Icon(
              themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            ),
            value: themeProvider.isDarkMode,
            onChanged: (bool value) {
              themeProvider.toggleTheme(value);
            },
          ),
          // Add student-specific settings here
        ],
      ),
    );
  }
}