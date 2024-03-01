import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:atlas/models/exercise.dart'; // Ensure this path is correct

class ExerciseSelectionPage extends StatefulWidget {
  @override
  _ExerciseSelectionPageState createState() => _ExerciseSelectionPageState();
}

class _ExerciseSelectionPageState extends State<ExerciseSelectionPage> {
  List<Exercise> exercises = []; // Updated to store Exercise objects

  @override
  void initState() {
    super.initState();
    _fetchExercises();
  }

  Future<void> _fetchExercises() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('exercises').get();
    List<Exercise> fetchedExercises = snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      return Exercise(
          name:
              data['exerciseName']); // Initializes Exercise objects with names
    }).toList();

    setState(() => exercises = fetchedExercises);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Exercise'),
      ),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(exercises[index].name),
            onTap: () {
              // Directly pass the Exercise name back
              Navigator.pop(context, exercises[index].name);
            },
          );
        },
      ),
    );
  }
}
