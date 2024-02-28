import 'package:flutter/material.dart';
import 'package:atlas/models/user.dart'; // Ensure this is the correct path for your User model
import 'package:atlas/screens/home/workout_page/exercise_selection_page.dart'; // Verify the path
import 'package:atlas/models/exercise.dart'; // Verify the path for your Exercise model

class WorkoutBuilder extends StatefulWidget {
  const WorkoutBuilder({Key? key}) : super(key: key);

  @override
  _WorkoutBuilderState createState() => _WorkoutBuilderState();
}

class _WorkoutBuilderState extends State<WorkoutBuilder> {
  String workoutName = '';
  String workoutDescription = '';
  List<Exercise> selectedExercises = [];

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
              TextField(
                decoration: InputDecoration(
                  labelText: 'Workout Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => workoutName = value,
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Workout Description',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => workoutDescription = value,
              ),
              SizedBox(height: 20),
              ...selectedExercises.asMap().entries.map((entry) {
                int idx = entry.key;
                Exercise exercise = entry.value;
                return ExerciseTile(
                  exercise: exercise,
                  onDelete: () =>
                      setState(() => selectedExercises.removeAt(idx)),
                  index: idx, // Pass the index to ExerciseTile
                );
              }).toList(),
              Center(
                child: ElevatedButton(
                  onPressed: () => _navigateAndDisplaySelection(context),
                  child: Text('Add Exercise'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    final String? exerciseName = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ExerciseSelectionPage()),
    );

    if (exerciseName != null) {
      _showAddExerciseDetailsDialog(exerciseName);
    }
  }

  Future<void> _showAddExerciseDetailsDialog(String exerciseName) async {
    TextEditingController setsController = TextEditingController();
    TextEditingController repsController = TextEditingController();
    TextEditingController weightController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button to dismiss the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Details for $exerciseName'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: setsController,
                  decoration: InputDecoration(labelText: 'Sets'),
                  keyboardType:
                      TextInputType.text, // Sets can be a range, hence text
                ),
                TextField(
                  controller: repsController,
                  decoration: InputDecoration(labelText: 'Reps'),
                  keyboardType:
                      TextInputType.text, // Reps can be a range, hence text
                ),
                TextField(
                  controller: weightController,
                  decoration: InputDecoration(labelText: 'Weight (lbs)'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                // Add the new exercise with details to the list
                setState(() {
                  selectedExercises.add(Exercise(
                    name: exerciseName,
                    sets: setsController.text,
                    reps: repsController.text,
                    weight: weightController.text,
                  ));
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class ExerciseTile extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onDelete;
  final int index; // Added index to track the exercise position

  const ExerciseTile({
    Key? key,
    required this.exercise,
    required this.onDelete,
    required this.index, // Require index in the constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '${index + 1}) ', // Display the exercise number
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(
                    exercise.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Text(
              'Sets: ${exercise.sets}, Reps: ${exercise.reps}, Weight: ${exercise.weight}lbs',
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
