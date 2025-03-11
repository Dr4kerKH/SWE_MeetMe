import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfessorListScreen extends StatefulWidget {
  const ProfessorListScreen({super.key});

  @override
  _ProfessorListScreenState createState() => _ProfessorListScreenState();
}

class _ProfessorListScreenState extends State<ProfessorListScreen> {
  late Future<List<dynamic>> _professorsFuture;

  @override
  void initState() {
    super.initState();
    _professorsFuture = fetchProfessors();
  }

  Future<List<dynamic>> fetchProfessors() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:5000/api/professors'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load professors: ${response.statusCode}');
      }
    } catch (error) {
      print("❌ Error fetching professors: $error");
      throw Exception("Could not load professors. Please try again later.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Available Professors")),
      body: FutureBuilder<List<dynamic>>(
        future: _professorsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No professors available"));
          }

          final professors = snapshot.data!;
          return ListView.builder(
            itemCount: professors.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(professors[index]['name']),
                  subtitle: Text(professors[index]['department']),
                  trailing: Text(
                    professors[index]['availability'] ?? "Not Available",
                    style: const TextStyle(color: Colors.green),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}