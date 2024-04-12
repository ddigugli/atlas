import 'package:atlas/models/user.dart';
import 'package:atlas/services/database.dart';
import 'package:flutter/material.dart';
import 'package:atlas/models/workout.dart';
import 'package:atlas/screens/home/shared_widgets/detailed_workout_page.dart';

class CreatedWorkoutsPage extends StatefulWidget {
  final AtlasUser user;

  const CreatedWorkoutsPage({super.key, required this.user});

  @override
  State<CreatedWorkoutsPage> createState() => _CreatedWorkoutsPageState();
}

class _CreatedWorkoutsPageState extends State<CreatedWorkoutsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // Horizontally center the title
        title: const Text(
          'Workouts',
          textAlign: TextAlign.center, // Center the text within the app bar
        ),
      ),
      body: FutureBuilder<List<Workout>>(
          future: DatabaseService().getCreatedWorkoutsByUser(
              widget.user.uid), // Use the followers future passed to the widget
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              List<Workout> workouts = (snapshot.data ?? []);

              return ListView.builder(
                  itemCount: workouts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      color: const Color.fromARGB(
                          255, 35, 35, 35), // Background color
                      child: ListTile(
                        title: Text(workouts[index].workoutName),
                        subtitle: Text(workouts[index].description),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailedWorkoutPage(workout: workouts[index]),
                            ),
                          );
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_forever_outlined),
                          onPressed: () async {
                            // Show a confirmation dialog
                            final bool confirmDelete = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: const Color.fromARGB(
                                          255, 173, 173, 173),
                                      title: const Text('Confirm'),
                                      content: const Text(
                                          'Are you sure you want to delete this workout?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text(
                                            'Cancel',
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255,
                                                  255,
                                                  255,
                                                  255), // Set the text color for 'Cancel' button
                                              fontWeight: FontWeight
                                                  .bold, // Make the text bold
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: const Text(
                                            'Delete',
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255,
                                                  255,
                                                  17,
                                                  0), // Set the text color for 'Delete' button
                                              fontWeight: FontWeight
                                                  .bold, // Make the text bold
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ) ??
                                false; // If showDialog was dismissed by tapping outside of the alert, it returns null

                            // If the user confirmed, then delete
                            if (confirmDelete) {
                              final bool didDelete =
                                  await DatabaseService().deleteWorkout(
                                workouts[index].workoutID,
                                widget.user.uid,
                              );

                              // If the delete operation is successful, update the state to remove the item from the list.
                              if (didDelete) {
                                setState(() {
                                  workouts.removeAt(index);
                                });
                              } else {
                                // If delete was not successful, you can show an error message or handle it accordingly.
                              }
                            }
                          },
                        ),
                      ),
                    );
                  });
            } else {
              return const Center(child: Text('No Workouts found'));
            }
          }),
    );
  }
}
