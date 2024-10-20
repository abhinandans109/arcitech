import 'package:arcitech/LoginFlow/user_login.dart';
import 'package:arcitech/Providers/item_provider.dart';
import 'package:arcitech/Providers/profile_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Home/home_screen.dart';
import 'Providers/user_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => ItemProvider()..fetchItems()),
          ChangeNotifierProvider(create: (_) => ProfileProvider()..fetchUserProfile()),
      ],
      child: const MaterialApp(
        home: AuthWrapper(),
      ),
    )

  );
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return const HomeScreen();
    } else {
      return LoginPage();
    }
  }
}



