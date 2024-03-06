import 'package:flutter/material.dart';
import 'package:atlas/services/database.dart';
import 'profile_wrapper.dart';
import 'package:atlas/models/user.dart';

class FollowingPage extends StatefulWidget {
  final Future<List<String>> following; // Assuming this is a list of user IDs

  const FollowingPage({Key? key, required this.following}) : super(key: key);

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  Future<List<AtlasUser>> _getFollowingUsers() async {
    List<String> userIds = await widget.following;
    List<AtlasUser> users = [];
    for (String userId in userIds) {
      var user = await DatabaseService().getAtlasUser(userId);
      users.add(user);
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Following'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<AtlasUser>>(
        future:
            _getFollowingUsers(), // Fetch following users as AtlasUser objects
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Consider customizing this message based on the error
            return const Center(
                child: Text('Something went wrong. Please try again later.'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var user = snapshot.data![index];
                return Card(
                  child: ListTile(
                    title: Text('@${user.username}'),
                    subtitle: Text('${user.firstName} ${user.lastName}'),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileWrapper(userID: user.uid),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No following found'));
          }
        },
      ),
    );
  }
}
