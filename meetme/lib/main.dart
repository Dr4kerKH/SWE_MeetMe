import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import 'screens/professor_homepage.dart';
import 'screens/student_homepage.dart';
import 'screens/coverscreen.dart';
import 'screens/loginpage.dart';
import 'screens/sign_up.dart';
import 'screens/theme_provider.dart';
import 'screens/professor_setting.dart';
import 'screens/student_setting.dart';
import 'screens/professor_list.dart';

void main() {
  runApp(const MeetMeApp());
}

class MeetMeApp extends StatefulWidget {
  const MeetMeApp({super.key});

  @override
  State<MeetMeApp> createState() => _MeetMeAppState();
}

class _MeetMeAppState extends State<MeetMeApp> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  bool isAuthenticated = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    String? token = await storage.read(key: "token");
    setState(() {
      isAuthenticated = token != null;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Meet Me App',
            themeMode: themeProvider.themeMode,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.blue,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.blueGrey,
              scaffoldBackgroundColor: Colors.black,
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: Colors.black,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.grey,
              ),
            ),

            initialRoute: isAuthenticated ? "/home" : "/cover",
            routes: {
              "/cover": (context) => const CoverScreen(),
              "/login": (context) => const LoginPage(),
              "/signup": (context) => const SignUpScreen(),
              "/home": (context) => const HomePage(),
              '/professor_home': (context) => const ProfessorHomePage(),
              "/professor_settings": (context) => const ProfessorSettings(),
              "/student_settings": (context) => const StudentSettings(),
              "/professor_list": (context) => ProfessorListScreen(),
            },
          );
        },
      ),
    );
  }
}
