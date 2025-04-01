import 'package:flutter/material.dart';
import 'student_pages.dart';
import 'api_service.dart';

void main() {
  runApp(const MeetMeApp());
}

class MeetMeApp extends StatelessWidget {
  const MeetMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meet Me',
      theme: ThemeData( // Color Collections
        // ** How to get the colors from the theme?
        // Theme.of(context).primaryColor,
        // Theme.of(context).secondaryHeaderColor,
        // Theme.of(context).hintColor,
        // Theme.of(context).scaffoldBackgroundColor,
        // Theme.of(context).shadowColor,
        primaryColor: const Color.fromARGB(255, 77, 11, 21), // Primary color
        secondaryHeaderColor: const Color.fromARGB(255, 140, 22, 39), // Secondary color
        hintColor: const Color.fromARGB(255, 82, 82, 82), // Grey color
        scaffoldBackgroundColor: const Color.fromARGB(255, 235, 235, 235), // Background color
        shadowColor: const Color.fromARGB(255, 10, 10, 10), // Shadow color
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 255, 255)),
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
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.26),
            child: Center(
              child: Image.asset(
                'assets/logo-png.png',
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
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).secondaryHeaderColor,
                    ]
                  ),
                  borderRadius: const BorderRadius.only(
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
                              style: TextStyle(
                                color: Theme.of(context).scaffoldBackgroundColor,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
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
                                    Icon(Icons.arrow_back_ios, color: Theme.of(context).scaffoldBackgroundColor,),
                                    Text(
                                      'Back',
                                      style: TextStyle(
                                        color: Theme.of(context).scaffoldBackgroundColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Center(
                                child: Text(
                                  'Are you a Professor or a Student?',
                                  style: TextStyle(
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                    fontSize: 24,
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
                                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                      ),
                                      child: Text('Professor',
                                        style: TextStyle(
                                          color: Theme.of(context).shadowColor,
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
                                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                      ),
                                      child: Text('Student',
                                        style: TextStyle(
                                          color: Theme.of(context).shadowColor,
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
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Theme.of(context).scaffoldBackgroundColor,
                                fontSize: 18,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email_outlined, color: Theme.of(context).scaffoldBackgroundColor,),
                                hintText: 'Email',
                                hintStyle: TextStyle(
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  fontSize: 18,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (_isSignUp)
                              TextField(
                                controller: _userController,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  fontSize: 18,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person_2_outlined, color: Theme.of(context).scaffoldBackgroundColor,),
                                  hintText: 'User Name',
                                  hintStyle: TextStyle(
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                    fontSize: 18,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Theme.of(context).scaffoldBackgroundColor,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Theme.of(context).scaffoldBackgroundColor,
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _passController,
                              textAlign: TextAlign.left,
                              obscureText: !_isPasswordVisible,
                              style: TextStyle(
                                color: Theme.of(context).scaffoldBackgroundColor,
                                fontSize: 18,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock_outline, color: Theme.of(context).scaffoldBackgroundColor,),
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  fontSize: 18,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Theme.of(context).scaffoldBackgroundColor,
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
                                    onPressed: () async {

                                      final email = _emailController.text.trim();
                                      final password = _passController.text.trim();
                                      final username = _userController.text.trim();
                                      final role = _isProfessor ? 'Professor' : (_isStudent ? 'Student' : null);

                                      try {
                                        if (_isSignUp) {
                                          await ApiService.createAccount(email, username, password, role!);

                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Account created. Please sign in.')),
                                          );

                                          // Switch back to Sign-In mode and reset professor/student state
                                          setState(() {
                                            _isSignUp = false;
                                            _isProfessor = false;
                                            _isStudent = false;
                                            _userController.clear();
                                          });

                                        } else {
                                          await ApiService.login(email, password);

                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(builder: (context) => const HomePage()),
                                          );
                                        }
                                      } catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Error: $e')),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                    ),
                                    child: Text(
                                      _isSignUp ? 'Continue' : 'Continue',
                                      style: TextStyle(
                                        color: Theme.of(context).shadowColor,
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
                                  style: TextStyle(
                                    color: Theme.of(context).shadowColor,
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w800,
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
                                    style:TextStyle(
                                      color: Theme.of(context).scaffoldBackgroundColor,
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
                              Text(
                                'Forget Password?',
                                style: TextStyle(
                                  color: Theme.of(context).scaffoldBackgroundColor,
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