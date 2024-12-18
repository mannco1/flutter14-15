import 'package:flutter/material.dart';
import 'package:pks/pages/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../pages/login.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ProfilePage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
// Есть неприятный баг, если выходить из профиля то приложение ломается и его надо презапускать, в чем проблема не понимаю.