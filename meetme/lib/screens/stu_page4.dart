import 'package:flutter/material.dart';

class StudentPage4 extends StatefulWidget {
  const StudentPage4({super.key});

  @override
  State<StudentPage4> createState() => _StudentPage4State();
}

class _StudentPage4State extends State<StudentPage4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color.fromARGB(255, 255, 2, 2),
                  const Color.fromARGB(255, 255, 255, 255),
                ]
              ),
            ),
          ),
          Center(
            child: const Text("Bonjour", 
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}