//This file is used to talk to firebase to get profile picture / upload a new one

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfilePictureService {
  // Firebase Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firebase Storage instance
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Function to fetch profile picture
  Future<String> getProfilePicture(String userid) async {
    try {
      // Attempt to get the user's profile picture URL document from Firestore
      DocumentSnapshot snapshot =
          await _firestore.collection('profilePictureURLs').doc(userid).get();

      String fileUrl;
      if (snapshot.exists && snapshot.data() is Map) {
        final data = snapshot.data() as Map<String, dynamic>;
        // If the document exists and has a URL, use it
        fileUrl = data['url'];
      } else {
        // If the document does not exist, use the default profile picture URL
        fileUrl = 'defaultpfp.jpeg';
      }

      // Get the download URL for the profile picture from Firebase Storage
      String imageUrl =
          await _storage.ref('profilepictures/$fileUrl').getDownloadURL();
      return imageUrl;
    } catch (e) {
      // In case of any errors, log them and return the default profile picture URL
      print('Error fetching profile picture: $e');
      return await _storage
          .ref('profilepictures/defaultpfp.jpeg')
          .getDownloadURL();
    }
  }
}
