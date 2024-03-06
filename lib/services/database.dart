import 'package:atlas/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:atlas/models/exercise.dart';
import 'package:atlas/models/workout.dart';

// Firestore initialization
FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference exercisesCollection = firestore.collection('exercises');
CollectionReference workoutsCollection = firestore.collection('workouts');
CollectionReference completedWorkoutsCollection =
    firestore.collection("completedWorkouts");

class DatabaseService {
  /* Function to get user's followers ids and return them as a list */
  Future<List> getFollowers(String userId) async {
    var doc = await firestore.collection('followers').doc(userId).get();
    if (doc.exists) {
      List followers = doc.data()?['followers'] ?? [];
      return followers;
    }
    return [];
  }

  /* Function to get user's following ids and return them as a list */
  Future<List> getFollowing(String userId) async {
    var doc = await firestore.collection('following').doc(userId).get();
    if (doc.exists) {
      List following = doc.data()?['following'] ?? [];
      return following;
    }
    return [];
  }

  //Write a function that gets the userId called getUserID from a username
  Future<String> getUserID(String username) async {
    var doc = await firestore
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
    if (doc.docs.isNotEmpty) {
      return doc.docs.first.id;
    }
    return '';
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

  Future<AtlasUser> getAtlasUser(String userId) async {
    var doc = await firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      return AtlasUser(
          uid: userId,
          email: doc.data()?['email'] ?? '',
          firstName: doc.data()?['firstName'] ?? '',
          lastName: doc.data()?['lastName'] ?? '',
          username: doc.data()?['username'] ?? '');
    } else {
      return AtlasUser(
          uid: '', email: '', firstName: '', lastName: '', username: '');
    }
  }

  Future<List> getWorkoutIDsByUser(String userId) async {
    var doc = await firestore.collection('workoutsByUser').doc(userId).get();
    if (doc.exists) {
      List workoutIDs = doc.data()?['workoutIDs'] ?? [];
      return workoutIDs;
    }
    return [];
  }

  //return a Workout object from a workout id

  Future<void> saveWorkout(Workout workout, String userId) async {
    DocumentReference workoutRef = await workoutsCollection.add({
      'createdBy': userId,
      'workoutName': workout.workoutName,
      'description': workout.description,
      'exercises': workout.exercises
          .map((exercise) => {
                'exerciseName': exercise.name,
                'sets': exercise.sets,
                'reps': exercise.reps,
                'weight': exercise.weight,
                'description': exercise.description,
                'equipment': exercise.equipment,
                'targetMuscle': exercise.targetMuscle,
              })
          .toList(),
    });

    // Update the workoutsByUser collection
    DocumentReference userWorkoutsRef =
        firestore.collection('workoutsByUser').doc(userId);
    await userWorkoutsRef.update({
      'workoutIDs': FieldValue.arrayUnion([workoutRef.id])
    });
  }

  //Write a function that returns a list of workouts from a list of workoutIDs
  Future<List<Workout>> getWorkoutsByUser(String userId) async {
    List workoutIDs = await getWorkoutIDsByUser(userId);
    List<Workout> workouts = [];

    for (var workoutID in workoutIDs) {
      try {
        // Call getWorkoutFromWorkoutID and wait for the result
        Workout workout = await getWorkoutFromWorkoutID(workoutID);
        workouts.add(workout);
      } catch (e) {
        print('Error fetching workout with ID $workoutID: $e');
        // Handle the error as needed
      }
    }

    return workouts;
  }

  // function that takes workout id and returns the workout object corresponding to that id
  Future<Workout> getWorkoutFromWorkoutID(String workoutID) async {
    DocumentSnapshot workoutDoc = await workoutsCollection.doc(workoutID).get();
    if (workoutDoc.exists) {
      return Workout(
          createdBy: workoutDoc['createdBy'],
          workoutName: workoutDoc['workoutName'],
          description: workoutDoc['description'],
          exercises: workoutDoc['exercises']
              .map<Exercise>((exercise) => Exercise(
                  name: exercise['exerciseName'],
                  sets: exercise['sets'],
                  reps: exercise['reps'],
                  weight: exercise['weight']))
              .toList());
    } else {
      throw Exception('Workout with ID $workoutID not found.');
    }
  }

  Future<List<List<dynamic>>> getCompletedWorkoutsByUser(String userId) async {
    var doc = await firestore.collection('completedWorkouts').doc(userId).get();

    if (doc.exists) {
      List workoutIDs = doc.data()?['workoutIDs'] ?? [];
      List timestamps = doc.data()?['timestamps'] ?? [];

      // Pair workout IDs with timestamps
      List<List<dynamic>> pairedData = [];
      for (int i = 0; i < workoutIDs.length; i++) {
        var workoutID = workoutIDs[i];
        if (i < timestamps.length) {
          // get timestamp of workout completion
          Timestamp timestamp = timestamps[i];

          // Fetch workout for the workout ID
          Workout workout = await getWorkoutFromWorkoutID(workoutID);

          // fetch user data
          AtlasUser user = await getAtlasUser(userId);

          // Pair workout with timestamp
          pairedData.add([workout, user, timestamp]);
        }
      }

      return pairedData;
    } else {
      return [];
    }
  }

  Future<List<List<dynamic>>> getActivityDashboardWorkouts(
      String userId) async {
    var followingSnapshot = await FirebaseFirestore.instance
        .collection('following')
        .doc(userId)
        .get();

    // get ids for people user is following
    List<String> userIds =
        List<String>.from(followingSnapshot.data()?['following'] ?? []);

    // get id of user because we will show user's own activity as well
    userIds.add(userId);

    // initialize empty list for completed workouts
    List<List<dynamic>> allCompletedWorkouts = [];
    for (String id in userIds) {
      List<List<dynamic>> completedWorkouts =
          await getCompletedWorkoutsByUser(id);
      allCompletedWorkouts.addAll(completedWorkouts);
    }

    // Sort allCompletedWorkouts by timestamp (index 2) in descending order
    allCompletedWorkouts
        .sort((a, b) => (b[2] as Timestamp).compareTo(a[2] as Timestamp));

    return allCompletedWorkouts;
  }
}
