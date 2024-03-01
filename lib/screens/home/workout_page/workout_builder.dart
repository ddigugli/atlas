import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // If you're using Firestore
import 'package:atlas/models/exercise.dart'; // Ensure this path is correct
import 'package:atlas/screens/home/workout_page/exercise_selection_page.dart'; // Verify the path
import 'package:atlas/services/database.dart'; // Verify the path
import 'package:atlas/models/user.dart';
import 'package:provider/provider.dart';

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
    final atlasUser = Provider.of<AtlasUser?>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Builder'),
        centerTitle: true, // Center the title text
        actions: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(
                vertical:
                    8), // Adjusts the button's vertical positioning and size
            decoration: BoxDecoration(
              color: const Color.fromARGB(
                  255, 19, 69, 109), // Background color of the butt  on
              borderRadius: BorderRadius.circular(
                  4), // Adjusts the roundness of button corners to make it rectangular
            ),
            child: TextButton(
              onPressed: () async {
                await DatabaseService().saveWorkout(atlasUser!.uid, workoutName,
                    workoutDescription, selectedExercises);
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Workout Saved!')));
                //return to previous page
                Navigator.pop(context);
              },
              child: Text('Save',
                  style: TextStyle(color: Colors.white)), // Text color
              style: TextButton.styleFrom(
                backgroundColor: Colors
                    .transparent, // Makes the TextButton's background transparent to reveal the Container's color
                padding: EdgeInsets.symmetric(
                    horizontal: 16), // Horizontal padding within the button
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        4)), // Matches the Container's borderRadius
              ),
            ),
          ),
        ],
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
                  onEdit: () => _showEditExerciseDialog(exercise, idx),
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
                  keyboardType: TextInputType.text,
                ),
                TextField(
                  controller: repsController,
                  decoration: InputDecoration(labelText: 'Reps'),
                  keyboardType: TextInputType.text,
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

  Future<void> _showEditExerciseDialog(Exercise exercise, int index) async {
    TextEditingController setsController =
        TextEditingController(text: exercise.sets);
    TextEditingController repsController =
        TextEditingController(text: exercise.reps);
    TextEditingController weightController =
        TextEditingController(text: exercise.weight);

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button to dismiss the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Details for ${exercise.name}'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: setsController,
                  decoration: InputDecoration(labelText: 'Sets'),
                  keyboardType: TextInputType.text,
                ),
                TextField(
                  controller: repsController,
                  decoration: InputDecoration(labelText: 'Reps'),
                  keyboardType: TextInputType.text,
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
              child: Text('Save'),
              onPressed: () {
                setState(() {
                  selectedExercises[index] = Exercise(
                    name: exercise.name,
                    sets: setsController.text,
                    reps: repsController.text,
                    weight: weightController.text,
                  );
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
  final VoidCallback onEdit;
  final int index;

  const ExerciseTile({
    Key? key,
    required this.exercise,
    required this.onDelete,
    required this.onEdit,
    required this.index,
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
                Text('${index + 1}) ',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Expanded(
                    child: Text(exercise.name,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))),
              ],
            ),
            Text(
                'Sets: ${exercise.sets}, Reps: ${exercise.reps}, Weight: ${exercise.weight}lbs'),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: onEdit),
                IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: onDelete),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
