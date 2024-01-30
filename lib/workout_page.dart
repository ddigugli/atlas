import 'package:flutter/material.dart';

// Workout Page
class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Workout Page'),
    );
  }
}