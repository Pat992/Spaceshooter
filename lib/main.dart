import 'package:flutter/material.dart';
import 'package:spaceshooter/screens/main_screen.dart';
import 'package:spaceshooter/screens/play_screen.dart';
import 'package:spaceshooter/screens/score_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spaceshooter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
      routes: {
        PlayScreen.ROUTE_NAME: (ctx) => PlayScreen(),
        ScoreScreen.ROUTE_NAME: (ctx) => ScoreScreen()
      },
    );
  }
}
