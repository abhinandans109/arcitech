import 'package:arcitech/Home/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/item_provider.dart';
import 'detail_screen.dart'; // Import the detail screen
import 'favourites_list.dart';
import 'item_card.dart'; // Import the ItemCard widget

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    getFCMToken();
    _initializeNotifications();
    // Fetch items on init
    // Provider.of<ItemProvider>(context, listen: false).fetchItems();
  }
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  void getFCMToken() async {
    String? token = await messaging.getToken();
    User? user = FirebaseAuth.instance.currentUser;
    print("FCM Token: $token");
    await FirebaseFirestore.instance.collection('userTokens').doc(user?.uid).set({
      'firebaseToken': token,
    });
    // Store token or use it to s
    // end notifications to this device
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Text('List of Photographers'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'favorites':
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const FavoritesScreen()),
                  );
                  break;
                case 'userDetails':
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'favorites',
                  child: Text('Favorites List'),
                ),
                const PopupMenuItem<String>(
                  value: 'userDetails',
                  child: Text('User Details'),
                ),
              ];
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0), // Set height of the search bar
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 10),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                fillColor: Colors.white,
                hintText: 'Search by photographer name',
                hintStyle: TextStyle(color: Colors.white),
                // border: OutlineInputBorder(
                //   borderSide:BorderSide(color: Colors.white,width: 2)
                // ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white,width: 1.5)
                ),

              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase(); // Update the search query
                });
              },
            ),
          ),
        ),
      ),
      body: Consumer<ItemProvider>(
        builder: (context, itemProvider, child) {
          if (itemProvider.isLoading) {
            return const Center(child: CircularProgressIndicator()); // Show loading indicator
          } else if (itemProvider.error != null) {
            return Center(child: Text(itemProvider.error!)); // Show error message
          } else {
            // Filter the items based on the search query
            final filteredItems = itemProvider.items.where((item) {
              return item.title.toLowerCase().contains(_searchQuery);
            }).toList();

            return ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    // Navigate to the details screen when an item is tapped
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DetailsScreen(item: filteredItems[index]),
                      ),
                    );
                  },
                  child: ItemCard(item: filteredItems[index]), // Reuse your ItemCard widget
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<void> _initializeNotifications() async {
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    messaging = FirebaseMessaging.instance;

    // Request permission for iOS
    messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get FCM token
    messaging.getToken().then((token) {
      print("FCM Token: $token");
      // You can store this token in Firestore for future use
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a message in the foreground: ${message.notification?.title}');
      if (message.notification != null) {
        _showNotification(message.notification!.title, message.notification!.body);
      }
    });

    // Handle background message
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked when app was in background!');
      // Handle navigation to specific screen
    });
  }

  // Show notification with title and body
  void _showNotification(String? title, String? body) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$title: $body')),
    );
  }
  }
