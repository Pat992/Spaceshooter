import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:spaceshooter/providers/images_provider.dart';
import 'package:spaceshooter/providers/preferences_provider.dart';
import 'package:spaceshooter/screens/play_screen.dart';
import 'package:spaceshooter/screens/score_screen.dart';
import 'package:spaceshooter/screens/start_screen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<PreferenceProvider>(context).initPreferences();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Spaceshooter',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        brightness: Brightness.dark,
      ),
      home: FutureBuilder(
        future: Provider.of<ImagesProvider>(context).initImages(),
        builder: (context, future) {
          return future.connectionState == ConnectionState.done
              ? StartScreen()
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
      routes: {
        PlayScreen.ROUTE_NAME: (ctx) => PlayScreen(),
        ScoreScreen.ROUTE_NAME: (ctx) => ScoreScreen()
      },
    );
  }
}
