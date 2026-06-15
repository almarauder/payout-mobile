import 'package:flutter/material.dart';
import 'package:payouts_platform/features/auth/screens/welcome_screen.dart';
import 'package:payouts_platform/features/auth/screens/login_screen.dart';
import 'package:payouts_platform/features/auth/screens/registration_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Payout Platform',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const WelcomeScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegistrationScreen(),
        '/home': (context) => const Scaffold(
          body: Center(child: Text('Home — в разработке')),
        ),
      },
    );
  }
}