import 'package:flutter/material.dart';
import 'package:shiny_hunt_tracker/screens/home_screen.dart';
import 'package:shiny_hunt_tracker/screens/hunt_creation_screen.dart';
import 'package:shiny_hunt_tracker/screens/hunt_detail_screen.dart';

import 'models/hunt.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shiny Hunt Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Define default font family
        fontFamily: 'Arial',
        // Define default TextTheme
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 18.0),
          bodySmall: TextStyle(fontSize: 16.0),
        ),
        // Define button styles
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, // Background color
            foregroundColor: Colors.white, // Text color
          ),
        ),
        // Define AppBar Theme
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: Colors.blue
        ),
      ),
      home: const HomeScreen(),
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        HuntCreationScreen.routeName: (context) => const HuntCreationScreen(),
        HuntDetailScreen.routeName: (context) => HuntDetailScreen(
          hunt: ModalRoute.of(context)!.settings.arguments as Hunt,
        ),
      },
    );
  }
}