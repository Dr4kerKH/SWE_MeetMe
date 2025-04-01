import 'package:flutter/material.dart';

class ProfessorPage5 extends StatefulWidget {
  const ProfessorPage5({super.key});

  @override
  State<ProfessorPage5> createState() => _ProfessorPage5State();
}

class _ProfessorPage5State extends State<ProfessorPage5> {
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