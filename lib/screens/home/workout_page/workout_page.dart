import 'package:flutter/material.dart';
import 'package:atlas/screens/home/workout_page/workout_builder.dart'; // Ensure this import path is correct

// Workout Page
class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // Horizontally center the title

        title: const Text('Workout Page'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 20.0), // Adjust the value as needed
              child: TextButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text('Create Workout',
                    style:
                        TextStyle(color: Color.fromARGB(255, 143, 197, 255))),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WorkoutBuilder(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
