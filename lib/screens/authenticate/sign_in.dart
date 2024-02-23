import 'package:flutter/material.dart';
import 'package:atlas/services/auth.dart';
import 'package:atlas/screens/authenticate/register.dart';

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
  String _errorMessage = '';

  void _signIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      var result = await _auth.signInWithEmailAndPassword(email, password);
      if (result != null) {
        print('Sign in successful.');
      } else {
        setState(() {
          _errorMessage =
              'User or Password not recognized'; // Update the error message
        });
        print('Sign in failed! Received null user');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Sign in failed. '; // Update the error message
      });
      print('Sign in failed with error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], // Gray background
      appBar: AppBar(
        title: Text('ATLAS', style: Theme.of(context).textTheme.headlineLarge),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome!',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors
                      .white), // White text for better contrast on dark background
            ),
            const SizedBox(height: 20),
            TextField(
              cursorColor: Colors.blue, // Set the cursor color to blue
              controller: _emailController,
              style: const TextStyle(
                  color: Colors.white), // White text for better contrast
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle:
                    TextStyle(color: Colors.white60), // Lighter text for label
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color:
                          Colors.blueGrey), // Custom color for enabled border
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors
                          .blue), // Change this color to whatever you prefer
                ),
                prefixIcon:
                    Icon(Icons.email, color: Colors.white60), // Icon color
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              cursorColor: Colors.blue, // Set the cursor color to blue
              controller: _passwordController,
              style: const TextStyle(
                  color: Colors.white), // White text for better contrast
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                labelStyle:
                    TextStyle(color: Colors.white60), // Lighter text for label
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color:
                          Colors.blueGrey), // Custom color for enabled border
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors
                          .blue), // Change this color to whatever you prefer
                ),
                prefixIcon:
                    Icon(Icons.lock, color: Colors.white60), // Icon color
              ),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(
                    top:
                        20.0), // Add 20 pixels of padding above the Text widget
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signIn, // Your sign-in method
              style: ElevatedButton.styleFrom(
                primary: Colors.blue[800], // Normal state color
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ).copyWith(
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.grey; // Color when the button is pressed
                    }
                    return null; // Use the default overlay color (transparent) in other states
                  },
                ),
              ),
              child:
                  const Text('Sign In', style: TextStyle(color: Colors.white)),
            ),
            const Padding(
              padding:
                  EdgeInsets.only(top: 20.0), // Adjust the padding as needed
              child: Divider(color: Colors.grey), // Thin gray separation line
            ),
            TextButton(
              onPressed: () {
                widget.toggleView();
              },
              child: RichText(
                text: const TextSpan(
                  text: 'New to Atlas? ',
                  style: TextStyle(color: Colors.white),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Register Now',
                        style: TextStyle(color: Colors.blue)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
