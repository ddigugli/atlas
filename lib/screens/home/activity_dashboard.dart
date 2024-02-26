import 'package:flutter/material.dart';
import 'package:atlas/services/auth.dart';
import 'package:atlas/services/database.dart';

class ActivityDashboard extends StatefulWidget {
  const ActivityDashboard({Key? key});

  @override
  State<ActivityDashboard> createState() => _ActivityDashboardState();
}

class _ActivityDashboardState extends State<ActivityDashboard> {
  late Future<List<Map<String, dynamic>>> _futureWorkouts;

  @override
  void initState() {
    super.initState();
    // Fetch the workouts data from Firestore
    _futureWorkouts = fetchWorkouts();
  }

  Future<List<Map<String, dynamic>>> fetchWorkouts() async {
    // Fetch the workouts associated with 'atlasfit' from the database
    DatabaseService databaseService = DatabaseService();
    String userID = 'j8GXXkrN9Mc7BMCrkfoMuaVUt3o1';
    return await databaseService.getWorkoutsByUserID(userID);
  }

  @override
  Widget build(BuildContext context) {
    //Add a button to sign out of firebase
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Dashboard'),
        actions: <Widget>[],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _futureWorkouts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              // Display workout details
              List<Map<String, dynamic>>? workoutsData = snapshot.data;
              if (workoutsData != null && workoutsData.isNotEmpty) {
                return ListView.builder(
                  itemCount: workoutsData.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> workout = workoutsData[index];
                    List<Map<String, dynamic>> exercises =
                        List<Map<String, dynamic>>.from(workout['exercises']);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Workout Name: ${workout['workoutName']}'),
                        Text('Description: ${workout['description']}'),
                        // Display exercises
                        const Text('Exercises:'),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: exercises.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> exercise = exercises[index];
                            return ListTile(
                              title: Text(
                                  'Exercise Name: ${exercise['exerciseName']}'),
                              subtitle: Text(
                                  'Sets: ${exercise['sets']}, Reps: ${exercise['reps']}, Rest Time: ${exercise['restTime']}'),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  },
                );
              } else {
                return const Text('No workout data available.');
              }
            }
          },
        ),
      ),
    );
  }
}
