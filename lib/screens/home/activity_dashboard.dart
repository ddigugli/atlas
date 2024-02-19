import 'package:flutter/material.dart';
import 'package:atlas/services/auth.dart';

// Activity Dashboard
class ActivityDashboard extends StatefulWidget {
  const ActivityDashboard({super.key});

  @override
  State<ActivityDashboard> createState() => _ActivityDashboardState();
}

class _ActivityDashboardState extends State<ActivityDashboard> {
  @override
  Widget build(BuildContext context) {
    //Add a button to sign out of firebase
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Dashboard'),
        actions: <Widget>[
          TextButton.icon(
            icon: const Icon(Icons.person),
            label: const Text('Sign Out'),
            onPressed: () async {
              // Add sign out functionality
              //Call signOut method from AuthService
              AuthService().signOut();
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: const Text('Activity Dashboard'),
      ),
    );
  }
}
