import 'package:atlas/models/workout.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'detailed_workout_page.dart';

/* A card widget that displays information about a completed workout. */
class ProfileCard extends StatelessWidget {
  final CompletedWorkout workout;

  /// Constructs a [ProfileCard] with the given [workout].
  const ProfileCard({
    super.key,
    required this.workout,
  });

  @override
  Widget build(BuildContext context) {
    /* Calculate the time difference between the current time and the time the workout was completed */
    final DateTime now = DateTime.now();
    final DateTime timestampDate = workout.completedTime.toDate();
    final Duration timeDifference = now.difference(timestampDate);

    String formattedTimestamp;
    if (timestampDate.year != now.year ||
        timestampDate.month != now.month ||
        timestampDate.day != now.day) {
      // If the post is not from today
      if (timestampDate.year == now.year &&
          timestampDate.month == now.month &&
          timestampDate.day == now.day - 1) {
        formattedTimestamp =
            'Yesterday at ${DateFormat('h:mm a').format(timestampDate)}'; // Format timestamp for yesterday
      } else {
        formattedTimestamp = DateFormat('h:mm a MMMM d, y')
            .format(timestampDate); // Format timestamp for more than 1 day ago
      }
    } else if (timeDifference.inHours >= 1) {
      formattedTimestamp =
          'Today at ${DateFormat('h:mm a').format(timestampDate)}'; // Format timestamp for today
    } else {
      formattedTimestamp =
          '${timeDifference.inMinutes} minutes ago'; // Format timestamp for less than 1 hour ago
    }

    return Card(
      color:
          const Color.fromARGB(255, 35, 35, 35), //CHANGE BACKGROUND COLOR HERE
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailedWorkoutPage(workout: workout),
            ),
          );
        },
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formattedTimestamp,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 8),
            Text(
              workout.workoutName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        subtitle: workout.description.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.description,
                    style: const TextStyle(fontSize: 14),
                  ),
                  //Text(
                  //  'Created by: ${workout.createdBy.firstName} ${workout.createdBy.lastName}',
                  //),
                ],
              )
            : Container(),
      ),
    );
  }
}
