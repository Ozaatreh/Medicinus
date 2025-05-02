import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medicinus/components/home_nav.dart';
import 'package:medicinus/pages/home_page.dart';
import 'package:medicinus/auth/login_page.dart';
import 'package:medicinus/pages/medicin_reminder.dart';

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()), // Show a loader while checking auth state
          );
        }

        if (snapshot.hasData) {
          return HomeNavigation(); // User is logged in, go to HomePage
        } else {
          return LoginPage(); // User is not logged in, go to LoginPage
        }
      },
    );
  }
}
