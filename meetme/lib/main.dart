import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

void main() {
  runApp(const MeetMeApp());
}

class MeetMeApp extends StatelessWidget {
  const MeetMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Booking Appointment',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LoadingScreen(),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  LoadingScreenState createState() => LoadingScreenState();
}

class LoadingScreenState extends State<LoadingScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _userController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isSignUp = false;
  bool _isProfessor = false;
  bool _isStudent = false;

  void _resetTextFields() {
    _emailController.clear();
    _passController.clear();
    _userController.clear();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background color
          Container(
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.26),
            child: Center(
              child: Image.asset(
                'assets/m2-meetme.png',
                width: 350, // Adjust the width as needed
                height: 350, // Adjust the height as needed
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.06,
            minChildSize: 0.06,
            maxChildSize: 0.5,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(235, 235, 45, 10),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView(
                    controller: scrollController,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 00),
                        child: Column(
                          textDirection: TextDirection.ltr,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isSignUp ? 'Create Account' : 'Sign In',
                              style: const TextStyle(
                                color: Color.fromARGB(255, 50, 50, 50),
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (_isSignUp && !_isProfessor && !_isStudent) ...[
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isSignUp = false;
                                    _resetTextFields();
                                  });
                                },
                                child: Row(
                                  children: [
                                    const Icon(Icons.arrow_back_ios, color: Color.fromARGB(255, 50, 50, 50),),
                                    const Text(
                                      'Back',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 50, 50, 50),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Center(
                                child: const Text(
                                  'Are you a Professor or a Student?',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 30),
                              Center(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  child: SizedBox(
                                    width: 330,
                                    height: 55,
                                    child: ElevatedButton(
                                      onPressed: () {
                                      setState(() {
                                        _isProfessor = true;
                                      });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(255, 225, 225, 230),
                                      ),
                                      child: const Text('Professor',
                                        style: TextStyle(
                                          color: Color.fromARGB(255, 10, 10, 10),
                                          fontSize: 24,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Center(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  child: SizedBox(
                                    width: 330,
                                    height: 55,
                                    child: ElevatedButton(
                                      onPressed: () {
                                      setState(() {
                                        _isStudent = true;
                                      });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(255, 225, 225, 230),
                                      ),
                                      child: const Text('Student',
                                        style: TextStyle(
                                          color: Color.fromARGB(255, 10, 10, 10),
                                          fontSize: 24,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ] else ...[
                            TextField(
                              controller: _emailController,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.email_outlined, color: Colors.white),
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 15,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (_isSignUp)
                              TextField(
                                controller: _userController,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 15,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.person_2_outlined, color: Colors.white),
                                  labelText: 'User Name',
                                  labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _passController,
                              textAlign: TextAlign.center,
                              obscureText: !_isPasswordVisible,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock_outline, color: Colors.white),
                                labelText: 'Password',
                                labelStyle: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 15,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),
                            Center(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                child: SizedBox(
                                  width: 330,
                                  height: 55,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const HomePage()),
                                      );
                                      // Handle sign-in or sign-up logic here},
                                      // For now, just print the email and password
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(255, 225, 225, 230),
                                    ),
                                    child: Text(
                                      _isSignUp ? 'Continue' : 'Continue',
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 10, 10, 10),
                                        fontSize: 24,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                Text(
                                  _isSignUp
                                      ? 'Already have an account?'
                                      : 'Don’t have an account?',
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isSignUp = !_isSignUp;
                                      _isProfessor = false;
                                      _isStudent = false;
                                      _resetTextFields();
                                    });
                                  },
                                  child: Text(
                                    _isSignUp ? 'Sign In' : 'Sign Up',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontSize: 15,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            if (!_isSignUp)
                              const Text(
                                'Forget Password?',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 15,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(235, 255, 255, 255),
        title: const Text(
          'Home',
          style: TextStyle(
            color: Color.fromARGB(255, 50, 50, 50),
            fontSize: 24,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: const Color.fromARGB(235, 255, 151, 133),
        child: const Center(
          child: Text('Hello, world!',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 36,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
        child: GNav(
          backgroundColor: const Color.fromARGB(235, 255, 255, 255),
          gap: 8,
          padding: EdgeInsets.all(16),
          tabs: const [
            GButton(
              icon: Icons.home_outlined,
              text: 'Home',
            ),
            GButton(
              icon: Icons.calendar_today_outlined,
              text: 'Calendar',
            ),
            GButton(
              icon: Icons.search_outlined,
              text: 'Search',
            ), 
            GButton(
              icon: Icons.settings_outlined,
              text: 'Profile',
            ),  
          ],
        ),
      ),
    );
  }
}