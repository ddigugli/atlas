import 'package:flutter/material.dart';

// Search Page
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  // Constructor for search page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      // App bar that has title for search page
      appBar: AppBar(
        title: Text('Find Friends, Workouts, and Groups', style: Theme.of(context).textTheme.titleMedium),
      ),

      // Creates body that contains search bar
      body: SearchAnchor(
        builder: (BuildContext context, SearchController controller) {
          return SearchBar(
            controller: controller, // set controller as a search controller for the search bar

            // Open search bar view if search bar is clicked or text is changed
            onTap: () {
              controller.openView();
            },
            onChanged: (_) {
              controller.openView();
            },

            // adds search icon to bar
            leading: const Icon(Icons.search),
          );
        }, 

        // create suggestions for search bar
        suggestionsBuilder: (BuildContext context, SearchController controller) {
          // TODO: Currently unfinished with numbered items as placeholders
          return List<ListTile>.generate(5, (int index) {
            final String item = 'item $index';

            // generate list tiles from items and if it is clicked, close view and update controller with item
            return ListTile(
              title: Text(item),
              onTap: () {
                setState(() {
                  controller.closeView(item);
                });
              },
            );
          });
        }),
      );
  }
}
