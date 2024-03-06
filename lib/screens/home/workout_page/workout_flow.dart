import 'package:flutter/material.dart';
import 'package:atlas/models/workout.dart';
import 'package:atlas/models/exercise.dart';

class WorkoutFlow extends StatefulWidget {
  @override
  _WorkoutFlowState createState() => _WorkoutFlowState();
}

class _WorkoutFlowState extends State<WorkoutFlow> {
  List<Exercise> exercises = [
    Exercise(name: 'Push-ups', sets: "3", reps: "10"),
    Exercise(name: 'Squats', sets: "3", reps: "12"),
    Exercise(name: 'Plank', sets: "3", reps: "30"),
    // Add more exercises here
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Flow'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Workout Name',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              exercises[currentIndex].name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: PageView.builder(
              itemCount: exercises.length,
              controller: PageController(viewportFraction: 0.8),
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(16.0),
                  elevation: 4, // Add elevation for a defined border
                  color: Colors.blueGrey[800], // Set a darker color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Add rounded corners
                    side: BorderSide(color: Colors.black, width: 1), // Add a border
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sets: ${exercises[currentIndex].sets}',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Reps: ${exercises[currentIndex].reps}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      )],
      ),
    );
  }
}