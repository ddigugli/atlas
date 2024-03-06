import 'package:atlas/models/user.dart';
import 'package:atlas/models/workout.dart';
import 'package:atlas/services/database.dart';
import 'package:atlas/shared/workout_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActivityDashboard extends StatefulWidget {
  const ActivityDashboard({super.key});

  @override
  State<ActivityDashboard> createState() => _ActivityDashboardState();
}

class _ActivityDashboardState extends State<ActivityDashboard> {
  @override
  Widget build(BuildContext context) {
    final atlasUser = Provider.of<AtlasUser?>(context);
    final userId = atlasUser?.uid ?? '';

    // Add a button to sign out of firebase
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Dashboard'),
      ),
      body: FutureBuilder<List<List<dynamic>>>(
        future: DatabaseService().getActivityDashboardWorkouts(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<List<dynamic>> data = snapshot.data ?? [];
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                Workout workout = data[index][0] as Workout;
                AtlasUser completedUser = data[index][1] as AtlasUser;
                Timestamp timestamp = data[index][2] as Timestamp;
                return WorkoutCard(
                  completedUser: completedUser,
                  workout: workout,
                  timestamp: timestamp,
                );
              },
            );
          } else {
            return const Center(child: Text('No Workouts found'));
          }
        },
      ),
    );
  }
}
