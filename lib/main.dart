import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payouts_platform/features/auth/screens/welcome_screen.dart';
import 'package:payouts_platform/features/auth/screens/login_screen.dart';
import 'package:payouts_platform/features/auth/screens/registration_screen.dart';
import 'package:payouts_platform/features/navigation/cubit/bottom_cubit.dart';
import 'package:payouts_platform/features/navigation/screens/root_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BottomCubit(),
        ),
      ], 
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Payout Platform',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const WelcomeScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegistrationScreen(),
        '/home': (context) => RootScreen(),
        },
      )
    );
  }
}