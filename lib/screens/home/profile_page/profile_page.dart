import 'package:flutter/material.dart';
import 'settings_page.dart';
import 'package:atlas/models/user.dart';
import 'package:provider/provider.dart';

// Profile Page
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    //Get AtlasUser
    final atlasUser = Provider.of<AtlasUser?>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const SizedBox(width: 40),
            Text('Profile', style: Theme.of(context).textTheme.titleLarge),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                  child: const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                        "https://image-cdn.essentiallysports.com/wp-content/uploads/arnold-schwarzenegger-volume-workout-1110x788.jpg"), // Ideally, replace with user's profile picture
                  ),
                ),
                const SizedBox(width: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15.0),
                    Text(
                      '${atlasUser?.firstName ?? "First"} ${atlasUser?.lastName ?? "Last"}',
                      style: const TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '@${atlasUser?.username ?? "username"}',
                      style: const TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5.0),
                    Row(children: const [
                      // Your existing widgets
                    ])
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            ...List.generate(
              10, // we would dynamically change this for each user depending on the number of workouts theyve posted
              (index) {
                return const Card(
                    child: ListTile(
                  title: Text(
                      "Recent Workout Card"), // placeholder until we decide how each card should look
                ));
              },
            )
          ]),
        ],
      ),
    );
  }
}
