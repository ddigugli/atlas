import 'package:flutter/material.dart';

// Activity Dashboard
class ActivityDashboard extends StatefulWidget {
  const ActivityDashboard({super.key});

  @override
  State<ActivityDashboard> createState() => _ActivityDashboardState();
}

class _ActivityDashboardState extends State<ActivityDashboard> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Activity Dashboard'),
    );
  }
}