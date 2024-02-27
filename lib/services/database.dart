import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// Firestore initialization
FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference exerciseCollection = firestore.collection('exercises');
CollectionReference workoutCollection = firestore.collection('workouts');

class DatabaseService {
  Future<String?> getUserIdByUsername(String username) async {
    try {
      // Query Firestore to find the document where username is equal to 'atlasfit'
      QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      // Check if there is a document with the given username
      if (querySnapshot.docs.isNotEmpty) {
        // Retrieve the userID from the first document (assuming username is unique)
        String userID = querySnapshot.docs.first['userID'];
        return userID;
      } else {
        // Username not found
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting userID by username: $e');
      }
      return null;
    }
  }

  // Method to add an exercise - each exercise must have unique name since the document ID is the exercise name
  Future<void> addExercise(String exerciseName, String description,
      String targetMuscle, String equipment, String type) async {
    try {
      await exerciseCollection.doc(exerciseName).set({
        'exerciseName': exerciseName,
        'description': description,
        'targetMuscle': targetMuscle,
        'equipment': equipment,
        'type': type
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error adding exercise: $e');
      }
    }
  }

  // Method to add a workout - workoutIDs must be unique since workouts can have the same name if they are made by different users
  Future<void> addWorkout(
      String workoutID,
      String workoutName,
      String userID,
      String description,
      bool verified,
      List<Map<String, dynamic>> exercises) async {
    try {
      await workoutCollection.doc(workoutID).set({
        'workoutName': workoutName,
        'createdBy': userID,
        'description': description,
        'verified': verified,
        'exercises':
            exercises // List of exercises with sets, reps, rest time, and exercise IDs
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error adding workout: $e');
      }
    }
  }

  // Method to fetch the workout data for a specific user
  Future<List<Map<String, dynamic>>> getWorkoutsByUserID(String userID) async {
    try {
      // Query Firestore to get the workouts for the given user
      QuerySnapshot workoutSnapshots =
          await workoutCollection.where('createdBy', isEqualTo: userID).get();

      // Check if there are any workouts
      if (workoutSnapshots.docs.isNotEmpty) {
        // Convert query snapshot to a list of workout data
        List<Map<String, dynamic>> workoutsData = [];
        for (var doc in workoutSnapshots.docs) {
          workoutsData.add(doc.data() as Map<String, dynamic>);
        }
        return workoutsData;
      } else {
        // No workouts found for the user
        return [];
      }
    } catch (e) {
      // Handle errors
      if (kDebugMode) {
        print('Error fetching workouts: $e');
      }
      throw Exception('Failed to fetch workouts');
    }
  }

  /* Function to get followers count */
  Future<List> getFollowersCount(String userId) async {
    var doc = await firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      List followers = doc.data()?['followers'] ?? [];
      return followers;
    }
    return [];
  }

  Future<List> getFollowingCount(String userId) async {
    var doc = await firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      List following = doc.data()?['following'] ?? [];
      return following;
    }
    return [];
  }

  //Function to get username, firstname and lastname from userid. Used in followers and following page
  Future<Map<String, dynamic>> getUserData(String userId) async {
    var doc = await firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      return {
        'username': doc.data()?['username'] ?? '',
        'firstName': doc.data()?['firstName'] ?? '',
        'lastName': doc.data()?['lastName'] ?? ''
      };
    }
    return {};
  }

  Future<List> getUsersWorkouts(String userId) async {
    var doc = await firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      List workouts = doc.data()?['workouts'] ?? [];
      return workouts;
    }
    return [];
  }
}
