import 'package:flutter/material.dart';
import 'package:atlas/services/database.dart'; // Import your DatabaseService
import 'package:atlas/screens/home/default_templates/default_profile.dart';

class FollowingPage extends StatefulWidget {
  final Future<List<dynamic>> following;

  const FollowingPage({super.key, required this.following});

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Following',
          textAlign: TextAlign.center, // Center the text within the app bar
        ),
        centerTitle: true, // Horizontally center the title
      ),
      body: FutureBuilder<List<dynamic>>(
        future:
            widget.following, // Use the followers future passed to the widget
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<dynamic> following = snapshot.data!;
            return ListView.builder(
              itemCount: following.length,
              itemBuilder: (context, index) {
                var userId = following[index];
                return FutureBuilder<Map<String, dynamic>>(
                  future: DatabaseService().getUserData(userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      Map<String, dynamic> user = snapshot.data!;
                      return Card(
                        child: ListTile(
                            title: Text(
                                '@${user['username']}'), // Corrected map access
                            subtitle: Text(
                                '${user['firstName'] ?? ''} ${user['lastName'] ?? ''}'), // Corrected map access with null check
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DefaultProfile(
                                      username: user['username']),
                                ),
                              );
                            }),
                      );
                    } else {
                      return const Center(child: Text('Not Following Anyone!'));
                    }
                  },
                );
                //
                // Access follower data assuming it's a Map
              },
            );
          } else {
            return const Center(child: Text('Not following Anyone!'));
          }
        },
      ),
    );
  }
}
