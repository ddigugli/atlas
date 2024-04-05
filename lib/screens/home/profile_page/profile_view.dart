import 'package:atlas/screens/home/shared_widgets/count_button.dart';
import 'package:atlas/screens/home/shared_widgets/following_unfollowing_button.dart';
import 'package:flutter/material.dart';
import 'package:atlas/services/database.dart';
import 'package:atlas/screens/home/profile_page/settings_page.dart';
import 'package:provider/provider.dart';
import 'package:atlas/models/user.dart';

class ProfileView extends StatefulWidget {
  final String userID;

  const ProfileView({super.key, required this.userID});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late Future<AtlasUser> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = DatabaseService().getAtlasUser(widget.userID);
  }

  Future<void> _refreshData() async {
    setState(() {
      _userDataFuture = DatabaseService().getAtlasUser(widget.userID);
    });
  }

  @override
  Widget build(BuildContext context) {
    final atlasUser = Provider.of<AtlasUser?>(context, listen: false);
    final userIdCurrUser = atlasUser?.uid ?? '';

    return FutureBuilder<AtlasUser>(
      future: _userDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text('Loading...')),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: const Center(child: Text('User not found or error occurred')),
          );
        }

        final AtlasUser userData = snapshot.data!;

        return RefreshIndicator(
          onRefresh: _refreshData,
          child: Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  const SizedBox(width: 40),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FutureBuilder<String>(
                          future:
                              DatabaseService().getProfilePicture(userData.uid),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            Widget imageWidget;
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting ||
                                !snapshot.hasData) {
                              imageWidget = const CircleAvatar(
                                radius: 35,
                                backgroundColor:
                                    Colors.grey, // Placeholder color
                              );
                            } else {
                              imageWidget = CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(snapshot.data!),
                              );
                            }
                            return imageWidget;
                          },
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${userData.firstName} ${userData.lastName}',
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                '@${userData.username}',
                                style: const TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      FollowingUnfollowingButton(
                        userIdCurrUser: userIdCurrUser,
                        userIdToFollow: userData.uid,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: CountButton(user: userData, label: 'Workouts'),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child:
                              CountButton(user: userData, label: 'Followers'),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child:
                              CountButton(user: userData, label: 'Following'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  const Divider(color: Colors.black, thickness: 2),
                  const SizedBox(height: 15.0),
                  // Add more widgets if needed
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
