import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/add_student.dart';
import 'package:firebase_crud/details.dart';
import 'package:firebase_crud/student.dart';
import 'package:firebase_crud/update_student.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('students');

  // List<Student> students = [
  bool isSearchClicked = false;
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: isSearchClicked
              ? Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: TextField(
                      decoration: const InputDecoration(hintText: 'Search...'),
                      onChanged: (value) {
                        setState(() {
                          searchText = value;
                        });
                      },
                    ),
                  ),
                )
              : const Text('Firebase CRUD'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  //
                  setState(() {
                    isSearchClicked = !isSearchClicked;
                  });
                  //
                },
                icon: Icon(isSearchClicked ? Icons.close : Icons.search))
          ],
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: _reference.get(),
          builder: (context, snapshot) {
            // Check for error
            if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong'),
              );
            }
            // if data received
            if (snapshot.hasData) {
              QuerySnapshot querySnapshot = snapshot.data!;
              List<QueryDocumentSnapshot> documents = querySnapshot.docs;
              // Convert data to List
              List<Student> students = documents
                  .map((e) => Student(
                      id: e['id'],
                      rollno: e['rollno'],
                      name: e['name'],
                      marks: e['marks']))
                  .toList();
              return _getBody(students);
            } else {
              // Show Loading
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
          // child: _getBody()
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (() {
            //
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddStudent(),
                ));
            //
          }),
          child: const Icon(Icons.add),
        ));
  }

  Widget _getBody(List<Student> students) {
    return students.isEmpty
        ? const Center(
            child: Text(
              'No Student Yet\nClick + to start adding',
              textAlign: TextAlign.center,
            ),
          )
        : searchText.isEmpty
            ? ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) =>
                    getCard(students, index, context))
            : ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  if (students[index]
                      .name
                      .toLowerCase()
                      .startsWith(searchText.toLowerCase())) {
                    return getCard(students, index, context);
                  }
                  return const SizedBox();
                },
              );
  }

  Card getCard(students, int index, BuildContext context) {
    return Card(
      color: students[index].marks < 33
          ? Colors.red.shade100
          : students[index].marks < 65
              ? Colors.yellow.shade100
              : Colors.green.shade100,
      child: ListTile(
        onTap: (() {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Details(student: students[index]),
              ));
        }),
        title: Text(students[index].name),
        subtitle: Text('Rollno: ${students[index].rollno}'),
        leading: CircleAvatar(
          radius: 25,
          child: Text('${students[index].marks}'),
        ),
        trailing: SizedBox(
          width: 60,
          child: Row(
            children: [
              InkWell(
                child: Icon(
                  Icons.edit,
                  color: Colors.black.withOpacity(0.75),
                ),
                onTap: () {
                  //
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UpdateStudent(student: students[index]),
                      ));
                  //
                },
              ),
              InkWell(
                child: const Icon(Icons.delete),
                onTap: () {
                  //
                  _reference.doc(students[index].id).delete();
                  // To refresh
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ));

                  //
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
