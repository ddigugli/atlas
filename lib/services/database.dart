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
  Future<List<String>> getFollowerIDs(String userId) async {
    var doc = await firestore.collection('followers').doc(userId).get();
    if (doc.exists) {
      List<dynamic> followersDynamic = doc.data()?['followers'] ?? [];
      // Explicitly cast each element in the list to String
      List<String> followers =
          followersDynamic.map((e) => e.toString()).toList();
      return followers;
    }
    return [];
  }

  /* Function to get user's following ids and return them as a list */
  Future<List<String>> getFollowingIDs(String userId) async {
    var doc = await firestore.collection('following').doc(userId).get();
    if (doc.exists) {
      List<dynamic> followingDynamic = doc.data()?['following'] ?? [];
      // Explicitly cast each element in the list to String
      List<String> following =
          followingDynamic.map((e) => e.toString()).toList();
      return following;
    }
    return [];
  }

  //TODO: MIGHT BE ABLE TO DELETE ONCE WE CHANGE TO FULL **MODULARITY**
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

  //TODO: FIX THIS IN DEFAULT_PROFILE Function to get username, firstname and lastname from userid. Used in followers and following page
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

  //TODO: THIS CAN BE MOVED TO ANOTHER FILE. Used in search page.
  Future<List<AtlasUser>> getUsers() async {
    QuerySnapshot querySnapshot = await firestore.collection('users').get();

    // Use Future.wait to wait for all the getAtlasUser futures to complete
    List<AtlasUser> users =
        await Future.wait(querySnapshot.docs.map((doc) async {
      return await getAtlasUser(doc.id);
    }));

    return users;
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
          //CONSIDER CHANGING TO NULL AND change Future<AtlasUser> to Future<Object>
          uid: '',
          email: '',
          firstName: '',
          lastName: '',
          username: '');
    }
  }

  Future<List<String>> getWorkoutIDsByUser(String userId) async {
    var doc = await firestore.collection('workoutsByUser').doc(userId).get();
    if (doc.exists) {
      List<dynamic> workoutIDsDynamic = doc.data()?['workoutIDs'] ?? [];
      // Explicitly cast each element in the list to String
      List<String> workoutIDs =
          workoutIDsDynamic.map((e) => e.toString()).toList();
      return workoutIDs;
    }
    return [];
  }

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
  Future<List<Workout>> getCreatedWorkoutsByUser(String userId) async {
    List<String> workoutIDs = await getWorkoutIDsByUser(userId);
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
    //Save to new CompletedWorkout() object and return that.
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
      //TODO:
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

  Future<void> followUser(String userIDCurrUser, String userIDOther) async {
    DocumentReference userFollowingRef =
        firestore.collection('following').doc(userIDCurrUser);
    DocumentReference otherUserFollowersRef =
        firestore.collection('followers').doc(userIDOther);

    // Transaction for userIDCurrUser's following update
    await firestore.runTransaction((transaction) async {
      DocumentSnapshot userFollowingSnapshot =
          await transaction.get(userFollowingRef);

      if (userFollowingSnapshot.exists) {
        List following = userFollowingSnapshot.get('following');
        if (!following.contains(userIDOther)) {
          following.add(userIDOther);
          transaction.update(userFollowingRef, {'following': following});
        }
      } else {
        transaction.set(userFollowingRef, {
          'following': [userIDOther]
        });
      }
    });

    // Transaction for userIDOther's followers update
    await firestore.runTransaction((transaction) async {
      DocumentSnapshot otherUserFollowersSnapshot =
          await transaction.get(otherUserFollowersRef);

      if (otherUserFollowersSnapshot.exists) {
        List followers = otherUserFollowersSnapshot.get('followers');
        if (!followers.contains(userIDCurrUser)) {
          followers.add(userIDCurrUser);
          transaction.update(otherUserFollowersRef, {'followers': followers});
        }
      } else {
        transaction.set(otherUserFollowersRef, {
          'followers': [userIDCurrUser]
        });
      }
    });
  }

  Future<void> unfollowUser(String userIDCurrUser, String userIDOther) async {
    DocumentReference userFollowingRef =
        firestore.collection('following').doc(userIDCurrUser);
    DocumentReference otherUserFollowersRef =
        firestore.collection('followers').doc(userIDOther);

    // Transaction for removing from userIDCurrUser's following
    await firestore.runTransaction((transaction) async {
      DocumentSnapshot userFollowingSnapshot =
          await transaction.get(userFollowingRef);

      if (userFollowingSnapshot.exists) {
        List following = userFollowingSnapshot.get('following');
        if (following.contains(userIDOther)) {
          following.remove(userIDOther);
          transaction.update(userFollowingRef, {'following': following});
        }
      }
    });

    // Transaction for removing from userIDOther's followers
    await firestore.runTransaction((transaction) async {
      DocumentSnapshot otherUserFollowersSnapshot =
          await transaction.get(otherUserFollowersRef);

      if (otherUserFollowersSnapshot.exists) {
        List followers = otherUserFollowersSnapshot.get('followers');
        if (followers.contains(userIDCurrUser)) {
          followers.remove(userIDCurrUser);
          transaction.update(otherUserFollowersRef, {'followers': followers});
        }
      }
    });
  }

  Future<bool> isFollowing(String userIDCurrUser, String userIDOther) async {
    DocumentSnapshot followingDoc =
        await firestore.collection('following').doc(userIDCurrUser).get();
    if (followingDoc.exists) {
      List followingList = followingDoc.get('following');
      return followingList.contains(userIDOther);
    }
    return false;
  }
}
