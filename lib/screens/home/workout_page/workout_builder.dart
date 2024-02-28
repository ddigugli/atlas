import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:atlas/models/user.dart';

// Workout Builder Page
class WorkoutBuilder extends StatefulWidget {
  const WorkoutBuilder({Key? key}) : super(key: key);

  @override
  _WorkoutBuilderState createState() => _WorkoutBuilderState();
}

class _WorkoutBuilderState extends State<WorkoutBuilder> {
  // Define your state variables here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Builder'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Your workout builder form fields and widgets here
              Text('Build your workout plan'),
              // Example: TextField(), DropdownButton(), etc.
            ],
          ),
        ),
      ),
      // Optionally, add a FloatingActionButton or ElevatedButton for actions like "Save Workout"
    );
  }

  // Define any functions for handling state changes, form submissions, etc., here
}
