import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:atlas/models/exercise.dart'; // Ensure this path is correct

class ExerciseSelectionPage extends StatefulWidget {
  const ExerciseSelectionPage({super.key});

  @override
  State<ExerciseSelectionPage> createState() => _ExerciseSelectionPageState();
}

class _ExerciseSelectionPageState extends State<ExerciseSelectionPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Exercise> exercises = [];
  List<Exercise> filteredExercises = [];

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
        name: data['exerciseName'],
        description: data['description'],
        equipment: data['equipment'],
        targetMuscle: data['targetMuscle'],
      );
    }).toList();

    setState(() {
      exercises = fetchedExercises;
      filteredExercises.addAll(exercises); // Populate filteredExercises with all exercises
    });
  }

  void filterExercises(String query) {
    setState(() {
      filteredExercises = exercises
          .where((exercise) =>
              exercise.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Exercise'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                filterExercises(value);
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search...',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredExercises.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredExercises[index].name),
                  onTap: () {
                    // Pass back the full Exercise object
                    Navigator.pop(context, filteredExercises[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
