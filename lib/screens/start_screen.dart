import 'package:flutter/material.dart';
import 'package:flutter_particle_background/flutter_particle_background.dart';
import 'package:provider/provider.dart';
import 'package:spaceshooter/providers/images_provider.dart';
import 'package:spaceshooter/screens/play_screen.dart';
import 'package:spaceshooter/screens/score_screen.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          ParticleBackground(
            backgroundColor: Colors.black,
            multiColor: true,
            numberOfParticles: 50,
            biggestSize: 10,
            smallestSize: 1,
            blur: true,
            allFilled: true,
            highestSpeed: 0.5,
            slowestSpeed: 0.2,
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: Text(
                    'Spaceshooter',
                    style: TextStyle(fontSize: 40),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.play_arrow),
                  label: Text('New Game'),
                  onPressed: () =>
                      Navigator.pushNamed(context, PlayScreen.ROUTE_NAME),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.list),
                  label: Text('Highscores'),
                  onPressed: () =>
                      Navigator.pushNamed(context, ScoreScreen.ROUTE_NAME),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
