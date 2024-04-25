import 'package:atlas/models/user.dart';
import 'package:atlas/screens/home/profile_page/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:atlas/services/database.dart';

/* This page allows users to search for other users, workouts, and groups */
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() =>F _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();
  List<AtlasUser> _userSuggestions = [];
  bool showSuggestions = false;

  void filterUsers(String query) async {
    if (query.isNotEmpty) {
      /* Search for users based on query */
      List<AtlasUser> users = await _databaseService.searchUsers(query);

      /* Update the user suggestions and show the suggestions */
      setState(() {
        _userSuggestions = users;
        showSuggestions = true;
      });
    } else {
      /* Clear the user suggestions and hide the suggestions */
      setState(() {
        _userSuggestions = [];
        showSuggestions = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Find Friends and Workouts',
            style: TextStyle(
              color: Color.fromARGB(255, 143, 197, 255),
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                filterUsers(value);
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search...',
              ),
            ),
          ),
          if (showSuggestions)
            Expanded(
              /* Display the user suggestions */
              child: ListView.builder(
                itemCount: _userSuggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_userSuggestions[index].username),
                    onTap: () {
                      /* Navigate to the profile view of the selected user */
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileView(
                            userID: _userSuggestions[index].uid,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
