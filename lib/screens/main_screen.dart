import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:spaceshooter/providers/preferences_provider.dart';
import 'package:spaceshooter/screens/play_screen.dart';
import 'package:spaceshooter/screens/score_screen.dart';
import 'package:spaceshooter/screens/start_screen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<PreferenceProvider>(context).initPreferences();
    return MaterialApp(
      title: 'Spaceshooter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StartScreen(),
      routes: {
        PlayScreen.ROUTE_NAME: (ctx) => PlayScreen(),
        ScoreScreen.ROUTE_NAME: (ctx) => ScoreScreen()
      },
    );
  }
}
