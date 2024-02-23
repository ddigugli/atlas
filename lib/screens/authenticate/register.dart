import 'package:flutter/material.dart';
import 'package:atlas/services/auth.dart';
import 'package:atlas/shared/constants.dart'; // Ensure this file exists and contains your textInputDecoration
import 'package:atlas/shared/loading.dart'; // Ensure this file exists and provides a loading widget

class Register extends StatefulWidget {
  final Function toggleView;

  Register({required this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  String _error = '';
  String _email = '';
  String _password = '';
  String _username = ''; // Add this line
  String _fullName = ''; // Add this line

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Loading() // Make sure the Loading widget exists and is implemented
        : Scaffold(
            backgroundColor: Colors.grey[900], // Gray background
            appBar: AppBar(
              title: Text('ATLAS',
                  style: Theme.of(context).textTheme.headlineLarge),
              centerTitle: true,
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  // Use SingleChildScrollView to avoid overflow when keyboard appears
                  child: Column(
                    children: <Widget>[
                      const Text(
                        'Create Account',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors
                                .white), // White text for better contrast on dark background
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        cursorColor:
                            Colors.blue, // Set the cursor color to blue
                        style: const TextStyle(
                            color:
                                Colors.white), // White text for better contrast

                        decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                              color: Colors.white60), // Lighter text for label
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .blueGrey), // Custom color for enabled border
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .blue), // Change this color to whatever you prefer
                          ),
                          prefixIcon: Icon(Icons.mail,
                              color: Colors.white60), // Icon color
                        ),
                        validator: (val) =>
                            val!.isEmpty ? 'Enter an email' : null,
                        onChanged: (val) => setState(() => _email = val),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        cursorColor:
                            Colors.blue, // Set the cursor color to blue
                        style: const TextStyle(
                            color:
                                Colors.white), // White text for better contrast

                        decoration: const InputDecoration(
                          labelText: 'Username',
                          labelStyle: TextStyle(
                              color: Colors.white60), // Lighter text for label
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .blueGrey), // Custom color for enabled border
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .blue), // Change this color to whatever you prefer
                          ),
                          prefixIcon: Icon(Icons.person,
                              color: Colors.white60), // Icon color
                        ),
                        validator: (val) =>
                            val!.isEmpty ? 'Enter a username' : null,
                        onChanged: (val) => setState(() => _username = val),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        cursorColor:
                            Colors.blue, // Set the cursor color to blue
                        style: const TextStyle(
                            color:
                                Colors.white), // White text for better contrast

                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          labelStyle: TextStyle(
                              color: Colors.white60), // Lighter text for label
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .blueGrey), // Custom color for enabled border
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .blue), // Change this color to whatever you prefer
                          ),
                          prefixIcon: Icon(Icons.person_2,
                              color: Colors.white60), // Icon color
                        ),
                        validator: (val) =>
                            val!.isEmpty ? 'Enter your full name' : null,
                        onChanged: (val) => setState(() => _fullName = val),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        cursorColor:
                            Colors.blue, // Set the cursor color to blue
                        style: const TextStyle(
                            color:
                                Colors.white), // White text for better contrast

                        decoration: const InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                              color: Colors.white60), // Lighter text for label
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .blueGrey), // Custom color for enabled border
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .blue), // Change this color to whatever you prefer
                          ),
                          prefixIcon: Icon(Icons.lock,
                              color: Colors.white60), // Icon color
                        ),
                        obscureText: true,
                        validator: (val) => val!.length < 6
                            ? 'Password must be at least 6 characters'
                            : null,
                        onChanged: (val) => setState(() => _password = val),
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue[800], // Normal state color
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                        ).copyWith(
                          overlayColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors
                                    .grey; // Color when the button is pressed
                              }
                              return null; // Use the default overlay color (transparent) in other states
                            },
                          ),
                        ),
                        child: Text('Register',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => _loading = true);
                            dynamic result =
                                await _auth.registerWithEmailAndPassword(
                                    _email,
                                    _password,
                                    _username,
                                    _fullName); // Pass _username and _fullName to your method
                            if (result == null) {
                              setState(() {
                                _error = 'Please supply a valid email';
                                _loading = false;
                              });
                            }
                          }
                        },
                      ),
                      SizedBox(height: 12.0),
                      Text(
                        _error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                            top: 1.0), // Adjust the padding as needed
                        child: Divider(
                            color: Colors.grey), // Thin gray separation line
                      ),
                      TextButton(
                        onPressed: () {
                          widget.toggleView();
                        },
                        child: RichText(
                          text: const TextSpan(
                            text: 'Have an account? ',
                            style: TextStyle(color: Colors.white),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Sign in',
                                  style: TextStyle(color: Colors.blue)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
