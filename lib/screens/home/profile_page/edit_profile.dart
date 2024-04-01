import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:atlas/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  // Function to pick an image
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Function to upload an image to Firebase Storage
  Future<void> _uploadImage(String userid) async {
    if (_image == null) return;

    String fileExtension = path.extension(_image!.path);
    String fileName =
        "$userid$fileExtension"; // Construct file name with new extension
    Reference storageRef =
        FirebaseStorage.instance.ref('profile_pictures/$fileName');

    // Upload the new file
    UploadTask uploadTask = storageRef.putFile(_image!);
    await uploadTask.whenComplete(() {});

    // No need to get the download URL if you're storing the filename in Firestore
    // Instead, store the fileName (which includes the extension) in Firestore
    await FirebaseFirestore.instance
        .collection('profilePictureURLs')
        .doc(userid)
        .set({
      'url': fileName, // Store the fileName as the url
    });

    print("Profile picture updated for user: $userid");
  }

  @override
  Widget build(BuildContext context) {
    final atlasUser = Provider.of<AtlasUser?>(context, listen: false);
    final userIdCurrUser = atlasUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null ? Image.file(_image!) : Text('No image selected.'),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            ElevatedButton(
              onPressed: () => _uploadImage(userIdCurrUser),
              child: Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}
