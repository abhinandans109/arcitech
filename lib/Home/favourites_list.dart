import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<String> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites(); // Load favorites from SharedPreferences
  }

  // Function to load favorites from SharedPreferences
  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _favorites = prefs.getStringList('favourites') ?? []; // Get the list of favorites
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites List'),
      ),
      body: _favorites.isEmpty // Check if favorites list is empty
          ? const Center(child: Text('No favorites yet!'))
          : ListView.builder(
        itemCount: _favorites.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4, // Add elevation for a shadow effect
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16), // Add padding
              title: Text(
                _favorites[index],
                style: const TextStyle(
                  fontSize: 18, // Increased font size
                  fontWeight: FontWeight.bold, // Bold text
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete), // Delete icon
                color: Colors.red, // Color for the delete icon
                onPressed: () {
                  _removeFromFavorites(_favorites[index]); // Remove item from favorites
                },
              ),
            ),
          );
        },
      ),
    );
  }

  // Function to remove an item from favorites
  Future<void> _removeFromFavorites(String itemName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favourites') ?? [];
    favorites.remove(itemName); // Remove the selected item
    await prefs.setStringList('favourites', favorites); // Save updated favorites
    _loadFavorites(); // Reload the favorites list
  }
}
