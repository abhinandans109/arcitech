import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/item_model.dart';

class DetailsScreen extends StatelessWidget {
  final Item item;
  const DetailsScreen({super.key, required this.item});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 5),
            onPressed: ()=>_markFavourite(context), icon: const Icon(Icons.star),)
        ],

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.network(
                  item.imageUrl,
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child; // Image has loaded
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  }
                },

              ),
              const SizedBox(height: 16),
              Text(
                'Photographer: ${item.title}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Photo URL: ${item.description}',
                style: const TextStyle(fontSize: 16, color: Colors.blue),
              ),
              const SizedBox(height: 16),
              const Text(
                'Additional Info: More details can be shown here like the photo dimensions, download link, or any other available info.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );

  }
  void _markFavourite (context) async {
    var prefs = await SharedPreferences.getInstance();
    var prevFavouriteList = prefs.getStringList('favourites') ?? [];
    if(!prevFavouriteList.contains(item.title)) {
      prevFavouriteList.add(item.title);
    }
    await prefs.setStringList('favourites', prevFavouriteList);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to Favourites')));
  }

}
