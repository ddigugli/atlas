import 'package:flutter/material.dart';
import 'package:atlas/screens/authenticate/register.dart';
import 'package:atlas/screens/authenticate/sign_in.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleView() {
    //print(showSignIn.toString());
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView: toggleView);
    } else {
      print(
          'IN authenticate.dart, should be registering but just signing in instead');
      return Register(toggleView: toggleView);
    }
  }
}
