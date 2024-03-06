import 'package:atlas/models/user.dart';
import 'package:atlas/models/workout.dart';
import 'package:atlas/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WorkoutCard extends StatelessWidget {
  final Workout workout;
  final Timestamp? timestamp;
  final AtlasUser? completedUser;

  const WorkoutCard({
    super.key,
    required this.workout,
    this.timestamp,
    this.completedUser,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final DateTime? timestampDate = timestamp?.toDate();
    final Duration timeDifference = now.difference(timestampDate ?? now);

    String formattedTimestamp;
    if (timeDifference.inDays > 1) {
      formattedTimestamp =
          DateFormat('h:mm a MMMM d, y').format(timestampDate!);
    } else if (timeDifference.inDays == 1) {
      formattedTimestamp =
          'Yesterday at ${DateFormat('h:mm a').format(timestampDate!)}';
    } else if (timeDifference.inHours >= 1) {
      formattedTimestamp =
          'Today at ${DateFormat('h:mm a').format(timestampDate!)}';
    } else {
      formattedTimestamp = '${timeDifference.inMinutes} minutes ago';
    }

    return FutureBuilder<AtlasUser?>(
      future: DatabaseService().getAtlasUser(workout.createdBy),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          AtlasUser? createdBy = snapshot.data;
          return Card(
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (timestamp != null) ...[
                    Text(
                        'Completed by: ${completedUser?.firstName} ${completedUser?.lastName}'),
                    const SizedBox(height: 4),
                    Text('Completed: $formattedTimestamp'),
                    const SizedBox(height: 8),
                  ],
                  Text(workout.workoutName),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(workout.description),
                  if (createdBy != null) ...[
                    const SizedBox(height: 8),
                    Text(
                        'Created by: ${createdBy.firstName} ${createdBy.lastName}'),
                  ],
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
