import 'package:firebase_crud/student.dart';
import 'package:flutter/material.dart';

class Details extends StatelessWidget {
  const Details({super.key, required this.student});
  final Student student;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Card(
                color: student.marks < 33
                    ? Colors.red.shade100
                    : student.marks < 65
                        ? Colors.yellow.shade100
                        : Colors.green.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.file_present,
                        size: 100,
                      ),
                      Text(
                        student.marks < 33
                            ? 'Fail'
                            : student.marks < 65
                                ? 'Pass'
                                : 'Distinct',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color:
                                student.marks < 33 ? Colors.red : Colors.green),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Name: ${student.name}',
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                'Marks: ${student.marks}',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: student.marks < 33 ? Colors.red : Colors.green),
              ),
              const SizedBox(height: 5),
              Text(
                'Rollno: ${student.rollno}',
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
