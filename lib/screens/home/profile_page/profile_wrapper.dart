import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:atlas/models/user.dart'; // Import your user model
import 'package:atlas/screens/home/profile_page/profile_page.dart'; // Import your ProfilePage
import 'package:atlas/screens/home/default_templates/default_profile.dart'; // Import your DefaultProfile page

class ProfileWrapper extends StatelessWidget {
  final String userID;

  const ProfileWrapper({Key? key, required this.userID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final atlasUser = Provider.of<AtlasUser?>(context);
    final userIdCurrUser = atlasUser?.uid ?? '';
    print('Current user ID: $userIdCurrUser');
    print('Other user ID: $userID');
    // Check if the provided userID matches the current user's ID
    if (userID == userIdCurrUser) {
      return ProfilePage(); // Navigate to the ProfilePage if IDs match
    } else {
      return DefaultProfile(
          otherUserId:
              userID); // Navigate to DefaultProfile if IDs do not match
    }
  }
}
