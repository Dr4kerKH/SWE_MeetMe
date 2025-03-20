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
                  const Color.fromARGB(255, 255, 255, 255),
                  const Color.fromARGB(255, 255, 199, 199),
                ]
              ),
              border: Border.all(
                color: Colors.transparent,
              ),
              shape: BoxShape.rectangle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(110, 0, 0, 0),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                //controller: _userController,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search_rounded, color: Color.fromARGB(255, 0, 0, 0)),
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 145, 145, 145),
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}