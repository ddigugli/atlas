import 'package:flutter/material.dart';
import 'package:atlas/screens/home/home_page.dart';
import 'package:json_theme/json_theme.dart';
import 'package:flutter/services.dart'; // For rootBundle
import 'package:provider/provider.dart';
import 'package:atlas/screens/authenticate/authenticate.dart';
import 'package:atlas/screens/home/home_page.dart';
import 'dart:convert'; //
import 'package:atlas/screens/authenticate/sign_in.dart'; // Assuming this is your sign-in page
import 'package:firebase_auth/firebase_auth.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context); //Refers to firebase user

    print(user);
    // return either the Home or Authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return const MyHomePage();
    }
  }
}
