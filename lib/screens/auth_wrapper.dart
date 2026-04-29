import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'main_shell.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        // Still waiting for auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Error state
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Something went wrong: ${snapshot.error}'),
            ),
          );
        }

        final User? user = snapshot.data;

        // User is logged in → show MainShell with unique key to prevent reuse bugs
        if (user != null) {
          return MainShell(key: ValueKey(user.uid));
        }

        // User is not logged in → show LoginScreen
        return const LoginScreen();
      },
    );
  }
}