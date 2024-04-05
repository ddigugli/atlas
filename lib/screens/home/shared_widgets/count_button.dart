import 'package:atlas/models/user.dart';
import 'package:atlas/screens/home/profile_page/created_workouts_page.dart';
import 'package:atlas/screens/home/profile_page/followers_page.dart';
import 'package:atlas/screens/home/profile_page/following_page.dart';
import 'package:flutter/material.dart';

class CountButton extends StatefulWidget {
  const CountButton({super.key, required this.user, required this.label});

  final AtlasUser user;
  final String label;

  @override
  State<CountButton> createState() => _CountButtonState();
}

class _CountButtonState extends State<CountButton> {
  late int count;

  @override
  Widget build(BuildContext context) {
    if (widget.label == 'Workouts') {
      count = widget.user.workoutCount;
    } else if (widget.label == 'Followers') {
      count = widget.user.followerCount;
    } else if (widget.label == 'Following') {
      count = widget.user.followingCount;
    }
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        foregroundColor: const Color.fromARGB(255, 143, 197, 255),
      ),
      /* Display the number of followers or following */
      child: Column(
        children: [
          Text('$count',
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          Text(widget.label,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
      onPressed: () {
        if (widget.label == 'Workouts') {
          Navigator.push(
            context,
            MaterialPageRoute(
                /* pass the list input to display on the corresponding page */
                builder: (context) => CreatedWorkoutsPage(user: widget.user)),
          );
        } else if (widget.label == 'Followers') {
          Navigator.push(
            context,
            MaterialPageRoute(
                /* pass the list input to display on the corresponding page */
                builder: (context) => FollowersPage(user: widget.user)),
          );
        } else if (widget.label == 'Following') {
          Navigator.push(
            context,
            MaterialPageRoute(
                /* pass the list input to display on the corresponding page */
                builder: (context) => FollowingPage(user: widget.user)),
          );
        }
      },
    );
  }
}
