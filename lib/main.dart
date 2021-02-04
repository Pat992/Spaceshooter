import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaceshooter/providers/enemy_provider.dart';
import 'package:spaceshooter/providers/images_provider.dart';
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
        ChangeNotifierProvider(create: (ctx) => ImagesProvider()),
        ChangeNotifierProvider(create: (ctx) => PlayerProvider()),
        ChangeNotifierProxyProvider<ImagesProvider, EnemyProvider>(
          create: (ctx) => EnemyProvider(null),
          update: (ctx, imagesProvider, enemyProvider) =>
              EnemyProvider(imagesProvider),
        )
      ],
      child: MainScreen(),
    );
  }
}
