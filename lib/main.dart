import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'on_boarding_screen.dart';
import 'leaderboard_screen.dart';
import 'home_screen.dart';
import 'quiz_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => OnboardingScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/leaderboard': (context) => LeaderboardScreen(),
        '/quiz': (context) => QuizScreen(),
      },
    );
  }
}
