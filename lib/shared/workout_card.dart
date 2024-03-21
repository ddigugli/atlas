import 'package:atlas/models/workout.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WorkoutCard extends StatelessWidget {
  final CompletedWorkout workout;

  const WorkoutCard({
    super.key,
    required this.workout,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final DateTime timestampDate = workout.completedTime.toDate();
    final Duration timeDifference = now.difference(timestampDate);

    String formattedTimestamp;
    if (timeDifference.inDays > 1) {
      formattedTimestamp = DateFormat('h:mm a MMMM d, y').format(timestampDate);
    } else if (timeDifference.inDays == 1) {
      formattedTimestamp =
          'Yesterday at ${DateFormat('h:mm a').format(timestampDate)}';
    } else if (timeDifference.inHours >= 1) {
      formattedTimestamp =
          'Today at ${DateFormat('h:mm a').format(timestampDate)}';
    } else {
      formattedTimestamp = '${timeDifference.inMinutes} minutes ago';
    }

    return Card(
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              /* Row containing User image + name + time completed */
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /* Column for image */
                const Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        "https://image-cdn.essentiallysports.com/wp-content/uploads/arnold-schwarzenegger-volume-workout-1110x788.jpg", // replace with user image
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                    width:
                        16), // Add spacing between image column and text column
                /* Column for name and time completed */
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${workout.completedBy.firstName} ${workout.completedBy.lastName}',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 2),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.task_alt, size: 12),
                        /* Check mark */
                        const SizedBox(width: 2),
                        /* aesthetic space */
                        Text(
                          '$formattedTimestamp',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              workout.workoutName,
              style: TextStyle(fontSize: 20),
            ),
            /*
            Text(
              workout.description,
              style: TextStyle(fontSize: 16),
            )
            */
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(workout.description),
            const SizedBox(height: 8),
            Text(
              'Created by: ${workout.createdBy.firstName} ${workout.createdBy.lastName}',
            ),
          ],
        ),
      ),
    );
  }
}
