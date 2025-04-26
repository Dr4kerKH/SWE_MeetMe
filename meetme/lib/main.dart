import 'package:flutter/material.dart';
import 'student_pages.dart';
import 'api_service.dart';
import 'professor_pages.dart';

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
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 77, 11, 21),
        secondaryHeaderColor: const Color.fromARGB(255, 140, 22, 39),
        hintColor: const Color.fromARGB(255, 82, 82, 82),
        scaffoldBackgroundColor: const Color.fromARGB(255, 235, 235, 235),
        shadowColor: const Color.fromARGB(255, 10, 10, 10),
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 255, 255, 255)),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: screenHeight * 0.26),
            child: Center(
              child: Image.asset(
                'assets/logo-png.png',
                width: isPortrait ? screenWidth * 0.85 : screenHeight * 0.85,
                height: isPortrait ? screenHeight * 0.35 : screenWidth * 0.35,
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.06,
            minChildSize: 0.06,
            maxChildSize: isPortrait ? 0.5 : 0.8,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).secondaryHeaderColor,
                      ]),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(screenWidth * 0.08),
                    topRight: Radius.circular(screenWidth * 0.08),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  child: ListView(
                    controller: scrollController,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.025,
                            vertical: screenHeight * 0.01),
                        child: Column(
                          textDirection: TextDirection.ltr,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isSignUp ? 'Create Account' : 'Sign In',
                              style: TextStyle(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                fontSize: screenWidth * 0.07,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.015),
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
                                    Icon(
                                      Icons.arrow_back_ios,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      size: screenWidth * 0.05,
                                    ),
                                    Text(
                                      'Back',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              Center(
                                child: Text(
                                  'Are you a Professor or a Student?',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    fontSize: screenWidth * 0.06,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.03),
                              Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(screenWidth * 0.025)),
                                  child: SizedBox(
                                    width: screenWidth * 0.85,
                                    height: screenHeight * 0.07,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _isProfessor = true;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                      ),
                                      child: Text(
                                        'Professor',
                                        style: TextStyle(
                                          color: Theme.of(context).shadowColor,
                                          fontSize: screenWidth * 0.06,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(screenWidth * 0.025)),
                                  child: SizedBox(
                                    width: screenWidth * 0.85,
                                    height: screenHeight * 0.07,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _isStudent = true;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                      ),
                                      child: Text(
                                        'Student',
                                        style: TextStyle(
                                          color: Theme.of(context).shadowColor,
                                          fontSize: screenWidth * 0.06,
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
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  fontSize: screenWidth * 0.045,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    size: screenWidth * 0.06,
                                  ),
                                  hintText: 'Email',
                                  hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    fontSize: screenWidth * 0.045,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(screenWidth * 0.025)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(screenWidth * 0.025)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.015),
                              if (_isSignUp)
                                TextField(
                                  controller: _userController,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    fontSize: screenWidth * 0.045,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.person_2_outlined,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      size: screenWidth * 0.06,
                                    ),
                                    hintText: 'User Name',
                                    hintStyle: TextStyle(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      fontSize: screenWidth * 0.045,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(screenWidth * 0.025)),
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(screenWidth * 0.025)),
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                      ),
                                    ),
                                  ),
                                ),
                              SizedBox(height: screenHeight * 0.015),
                              TextField(
                                controller: _passController,
                                textAlign: TextAlign.left,
                                obscureText: !_isPasswordVisible,
                                style: TextStyle(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  fontSize: screenWidth * 0.045,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.lock_outline,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    size: screenWidth * 0.06,
                                  ),
                                  hintText: 'Password',
                                  hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    fontSize: screenWidth * 0.045,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(screenWidth * 0.025)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(screenWidth * 0.025)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      size: screenWidth * 0.06,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible =
                                            !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.025),
                              Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(screenWidth * 0.025)),
                                  child: SizedBox(
                                    width: screenWidth * 0.85,
                                    height: screenHeight * 0.07,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        final email =
                                            _emailController.text.trim();
                                        final password =
                                            _passController.text.trim();
                                        final username =
                                            _userController.text.trim();
                                        final role = _isProfessor
                                            ? 'Professor'
                                            : (_isStudent ? 'Student' : null);

                                        try {
                                          if (_isSignUp) {
                                            await ApiService.createAccount(
                                                email,
                                                username,
                                                password,
                                                role!);

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Account created. Please sign in.',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize:
                                                        screenWidth * 0.04,
                                                    color: Theme.of(context)
                                                        .shadowColor,
                                                  ),
                                                ),
                                                backgroundColor: Theme.of(
                                                        context)
                                                    .scaffoldBackgroundColor,
                                                duration:
                                                    const Duration(seconds: 2),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          screenWidth * 0.03),
                                                ),
                                                margin: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .padding
                                                          .top +
                                                      screenHeight * 0.01,
                                                  left: screenWidth * 0.04,
                                                  right: screenWidth * 0.04,
                                                ),
                                              ),
                                            );

                                            setState(() {
                                              _isSignUp = false;
                                              _isProfessor = false;
                                              _isStudent = false;
                                              _userController.clear();
                                            });
                                          } else {
                                            try {
                                              final role =
                                                  await ApiService.login(
                                                      email, password);

                                              if (role == 'Professor') {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const ProfessorHomePage()),
                                                );
                                              } else if (role == 'Student') {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const StudentHomePage()),
                                                );
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      "Unknown user role",
                                                      style: TextStyle(
                                                        fontSize:
                                                            screenWidth * 0.04,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    "Login failed: $e",
                                                    style: TextStyle(
                                                      fontSize:
                                                          screenWidth * 0.04,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                          }
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Error: $e',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: screenWidth * 0.04,
                                                  color: Theme.of(context)
                                                      .shadowColor,
                                                ),
                                              ),
                                              backgroundColor: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              duration:
                                                  const Duration(seconds: 2),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        screenWidth * 0.03),
                                              ),
                                              margin: EdgeInsets.only(
                                                top: MediaQuery.of(context)
                                                        .padding
                                                        .top +
                                                    screenHeight * 0.01,
                                                left: screenWidth * 0.04,
                                                right: screenWidth * 0.04,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                      ),
                                      child: Text(
                                        _isSignUp ? 'Continue' : 'Continue',
                                        style: TextStyle(
                                          color: Theme.of(context).shadowColor,
                                          fontSize: screenWidth * 0.06,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.015),
                              Row(
                                children: [
                                  Text(
                                    _isSignUp
                                        ? 'Already have an account?'
                                        : 'Don\'t have an account?',
                                    style: TextStyle(
                                      color: Theme.of(context).shadowColor,
                                      fontSize: screenWidth * 0.037,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.01),
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
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        fontSize: screenWidth * 0.037,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.005),
                              if (!_isSignUp)
                                Text(
                                  'Forget Password?',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    fontSize: screenWidth * 0.037,
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
