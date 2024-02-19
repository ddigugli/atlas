import 'package:flutter/material.dart';
import 'package:atlas/services/auth.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({required this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _auth = AuthService();

  void _signIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      // Attempt to sign in the user with Firebase Auth
      var result = await _auth.signInWithEmailAndPassword(email, password);
      if (result != null) {
        // Assuming result is a UserCredential object, and checking if it's not null
        // Navigate to your app's home screen
        print('Sign In Successful');
        // Navigator.of(context).pushReplacementNamed('/home'); // Example navigation
      } else {
        // This block might not be necessary if you're throwing an exception on failure
        print('Sign in failed. Received null user.');
      }
    } catch (e) {
      // Handle error, e.g., show an error message
      print('Sign in failed with error: $e');
    }
  }

  /* USER INTERFACE PART OF CODE*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In Page'),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: 'Password'),
          ),
          ElevatedButton(
            onPressed: _signIn,
            child: Text('Sign In'),
          ),
        ],
      ),
    );
  }
}
