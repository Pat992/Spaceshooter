import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaceshooter/providers/enemy_provider.dart';
import 'package:spaceshooter/providers/player_provider.dart';
import 'package:spaceshooter/providers/preferences_provider.dart';
import 'package:spaceshooter/screens/main_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => PreferenceProvider()),
        ChangeNotifierProvider(create: (ctx) => Player(0, 0, 10)),
        ChangeNotifierProvider(create: (ctx) => Enemy(0, 0, 10))
      ],
      child: MainScreen(),
    );
  }
}
