import 'package:flutter/material.dart';

class StudentPage5 extends StatefulWidget {
  const StudentPage5({super.key});

  @override
  State<StudentPage5> createState() => _StudentPage5State();
}

class _StudentPage5State extends State<StudentPage5> {
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
            child: const Text("Hola", 
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