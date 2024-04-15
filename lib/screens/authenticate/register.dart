import 'package:flutter/material.dart';
import 'package:atlas/services/auth.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  const Register({super.key, required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  String _error = '';
  String _email = '';
  String _password = '';
  String _username = '';
  String _fullName = '';

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(
            child: SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            body: Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg.jpg'),
                  alignment: Alignment(0, 0.5),
                  fit: BoxFit.cover,
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey, // Assign the form key
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2),
                      const Text(
                        'Create Account', // Display the heading
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        cursorColor: Colors.blue,
                        decoration: const InputDecoration(
                          labelText: 'Email', // Display the email label
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.mail),
                          filled: true,
                          fillColor: Color.fromRGBO(255, 255, 255, 0.1),
                        ),
                        validator: (val) => val!.isEmpty
                            ? 'Enter an email'
                            : null, // Validate email field
                        onChanged: (val) => setState(
                            () => _email = val), // Update _email variable
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        cursorColor: Colors.blue,
                        decoration: const InputDecoration(
                          labelText: 'Username', // Display the username label
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                          filled: true,
                          fillColor: Color.fromRGBO(255, 255, 255, 0.1),
                        ),
                        validator: (val) => val!.isEmpty
                            ? 'Enter a username'
                            : null, // Validate username field
                        onChanged: (val) => setState(
                            () => _username = val), // Update _username variable
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        cursorColor: Colors.blue,
                        decoration: const InputDecoration(
                          labelText: 'Full Name', // Display the full name label
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                          filled: true,
                          fillColor: Color.fromRGBO(255, 255, 255, 0.1),
                        ),
                        validator: (val) => val!.isEmpty
                            ? 'Enter your full name'
                            : null, // Validate full name field
                        onChanged: (val) => setState(
                            () => _fullName = val), // Update _fullName variable
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        cursorColor: Colors.blue,
                        decoration: const InputDecoration(
                          labelText: 'Password', // Display the password label
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                          filled: true,
                          fillColor: Color.fromRGBO(255, 255, 255, 0.1),
                        ),
                        obscureText: true,
                        validator: (val) => val!.length < 6
                            ? 'Password must be at least 6 characters' // Validate password field
                            : null,
                        onChanged: (val) => setState(
                            () => _password = val), // Update _password variable
                      ),
                      const SizedBox(height: 20.0),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width *
                              0.9, // Set width to 75% of the screen width
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() =>
                                    _loading = true); // Set _loading to true
                                dynamic result =
                                    await _auth.registerWithEmailAndPassword(
                                        _email,
                                        _password,
                                        _username,
                                        _fullName); // Call the registerWithEmailAndPassword method
                                if (result == null) {
                                  setState(() {
                                    _error =
                                        'Email or username already taken'; // Set _error message
                                    _loading = false; // Set _loading to false
                                  });
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(255, 255, 255, 1),
                                fontWeight: FontWeight.w900,
                              ),
                              backgroundColor: const Color.fromRGBO(
                                  33, 150, 243, 0.3), //Colors.white
                              //  .withOpacity(0.1), // Slightly transparent background

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    5.0), // Rounded corners
                                // White border
                              ),
                            ),

                            child: const Text(
                                'Register'), // Display the register button
                          ),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        _error, // Display the error message
                        style:
                            const TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 1.0),
                        child: Divider(color: Colors.grey), // Display a divider
                      ),
                      TextButton(
                        onPressed: () {
                          widget.toggleView(); // Call the toggleView method
                        },
                        child: RichText(
                          text: const TextSpan(
                            text:
                                'Have an account? ', // Display the "Have an account?" text
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Sign in', // Display the "Sign in" text
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold)),
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
