import 'package:atlas/screens/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:json_theme/json_theme.dart';
import 'package:firebase_core/firebase_core.dart'; // Add this line
import 'package:flutter/services.dart'; // For rootBundle
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:atlas/services/database.dart';
import 'package:atlas/models/user.dart';
import 'package:atlas/services/auth.dart';
import 'package:uuid/uuid.dart';

import 'dart:convert'; //

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Load theme
  final themeStr = await rootBundle.loadString('assets/appainter_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;

  DatabaseService databaseService = DatabaseService();

  // Lookup user ID by username
  String userID = 'j8GXXkrN9Mc7BMCrkfoMuaVUt3o1';
  // User ID found, proceed with adding workout
  List<Map<String, dynamic>> exerciseList = [
    {'exerciseID': 'Pushups', 'sets': 3, 'reps': 10, 'restTime': '60s'},
    {'exerciseID': 'Pushups', 'sets': 3, 'reps': 12, 'restTime': '60s'},
    // Add more exercises as needed
  ];

  // Generate a random workout ID
  // var uuid = const Uuid();
  // String workoutID = uuid.v4();

  String workoutID = '20a1f112-52c3-40d2-a974-fd50222a82e3';

  // Add workout
  await databaseService.addWorkout(
    workoutID,
    'Test Workout',
    userID,
    'Test workout',
    true,
    exerciseList,
  );

  // Run the app
  runApp(MainApp(theme: theme));
}

class MainApp extends StatelessWidget {
  final ThemeData theme;

  const MainApp({super.key, required this.theme});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<AtlasUser?>.value(
      value: AuthService().atlasUser,
      initialData: null,
      child: MaterialApp(home: Wrapper(), theme: theme),
    );
  }
}
