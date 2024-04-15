import 'package:atlas/models/user.dart';
import 'package:atlas/services/database.dart';
import 'package:flutter/material.dart';
import 'package:atlas/models/workout.dart';
import 'package:atlas/screens/home/shared_widgets/detailed_workout_page.dart';
import 'package:provider/provider.dart';
import 'package:atlas/screens/home/workout_page/workout_builder.dart';

enum WorkoutAction { edit, delete }

class CreatedWorkoutsPage extends StatefulWidget {
  final AtlasUser user;

  const CreatedWorkoutsPage({super.key, required this.user});

  @override
  State<CreatedWorkoutsPage> createState() => _CreatedWorkoutsPageState();
}

class _CreatedWorkoutsPageState extends State<CreatedWorkoutsPage> {
  @override
  Widget build(BuildContext context) {
    final atlasUser = Provider.of<AtlasUser?>(context, listen: false);
    final userIdCurrUser = atlasUser?.uid ?? '';

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
                        leading: const Icon(Icons.fitness_center,
                            color: Color.fromARGB(255, 143, 197, 255)),
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
                        trailing: widget.user.uid == userIdCurrUser
                            ? PopupMenuButton<String>(
                                onSelected: (String value) async {
                                  if (value == 'delete') {
                                    // Show a confirmation dialog
                                    final bool confirmDelete = await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 173, 173, 173),
                                              title: const Text('Confirm'),
                                              content: const Text(
                                                  'Are you sure you want to delete this workout?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(false),
                                                  child: const Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(true),
                                                  child: const Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 255, 17, 0),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ) ??
                                        false; // Handle dismiss outside touch as cancel

                                    if (confirmDelete) {
                                      final bool didDelete =
                                          await DatabaseService().deleteWorkout(
                                        workouts[index].workoutID,
                                        widget.user.uid,
                                      );

                                      if (didDelete) {
                                        setState(() {
                                          workouts.removeAt(index);
                                        });
                                      } else {
                                        // Handle unsuccessful deletion
                                      }
                                    }
                                  } else if (value == 'edit') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WorkoutBuilder(
                                          initialWorkout: workouts[index],
                                        ),
                                      ),
                                    );
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                  const PopupMenuItem<String>(
                                    value: 'edit',
                                    child: Row(children: [
                                      Icon(Icons.edit,
                                          color: Color.fromARGB(
                                              255, 143, 197, 255)), // Edit icon
                                      SizedBox(
                                          width:
                                              8), // Space between icon and text
                                      Text('Edit Workout'),
                                    ]),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Row(children: [
                                      Icon(Icons.delete,
                                          color:
                                              Color.fromARGB(255, 255, 94, 73)),
                                      SizedBox(width: 8),
                                      Text('Delete')
                                    ]),
                                  ),
                                ],
                                icon: const Icon(
                                  Icons.more_horiz_outlined,
                                ),
                                color: const Color.fromARGB(255, 75, 75, 75),
                                // Text style for items
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Rounded corners
                                ),
                              )
                            : null,
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
