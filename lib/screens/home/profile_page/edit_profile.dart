import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:atlas/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:atlas/services/database.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _image; // ignore: unused_field
  final ImagePicker _picker = ImagePicker();
  String? _profilePictureUrl; // ignore: unused_field
  //NEED TO IGNORE UNUSED FIELD. Can't delete those fields.

  @override
  void initState() {
    super.initState();
    _fetchProfilePicture();
  }

  Future<void> _fetchProfilePicture() async {
    final atlasUser = Provider.of<AtlasUser?>(context, listen: false);
    final userId = atlasUser?.uid ?? '';
    // Assuming you have a method in your database service to get the profile picture URL
    final url = await DatabaseService().getProfilePicture(userId);
    setState(() {
      _profilePictureUrl = url;
    });
  }

  Future<void> _pickAndUploadImage(String userId) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File image = File(pickedFile.path);
      setState(() {
        _image = image;
      });
      await _uploadImage(userId, image);
      await _fetchProfilePicture(); // Refresh profile picture after uploading
    }
  }

  Future<void> _uploadImage(String userId, File image) async {
    String fileExtension = path.extension(image.path);
    String fileName = "$userId$fileExtension";
    Reference storageRef =
        FirebaseStorage.instance.ref('profilepictures/$fileName');
    await storageRef.putFile(image);
    // Update Firestore with the new file name
    await FirebaseFirestore.instance
        .collection('profilePictureURLs')
        .doc(userId)
        .set({
      'url': fileName,
    });
  }

  @override
  Widget build(BuildContext context) {
    final atlasUser = Provider.of<AtlasUser?>(context, listen: false);
    final userIdCurrUser = atlasUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(
            20.0), // Add padding around the content for better aesthetics
        child: Column(
          mainAxisAlignment: MainAxisAlignment
              .start, // Align the column to the start of the main axis (vertical)
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .center, // Center the row content along the x-axis
              children: [
                FutureBuilder<String>(
                  future: DatabaseService().getProfilePicture(userIdCurrUser),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    Widget imageWidget;
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        !snapshot.hasData) {
                      imageWidget = const CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.grey, // Placeholder color
                      );
                    } else {
                      imageWidget = CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(snapshot.data!),
                      );
                    }
                    return imageWidget;
                  },
                ),
                const SizedBox(width: 20), // Spacing between picture and button
                TextButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text(
                    'Edit Profile Picture',
                    style: TextStyle(color: Color.fromARGB(255, 143, 197, 255)),
                  ),
                  onPressed: () => _pickAndUploadImage(userIdCurrUser),
                ),
              ],
            ),
            // You can add more widgets below in this Column if needed
          ],
        ),
      ),
    );
  }
}
