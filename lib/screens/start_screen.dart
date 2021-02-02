import 'package:flutter/material.dart';
import 'package:spaceshooter/screens/play_screen.dart';
import 'package:spaceshooter/screens/score_screen.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Spaceshooter',
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ElevatedButton.icon(
                icon: Icon(Icons.list),
                label: Text('Highscores'),
                onPressed: () =>
                    Navigator.pushNamed(context, ScoreScreen.ROUTE_NAME),
              ),
              SizedBox(
                width: 10,
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.play_arrow),
                label: Text('New Game'),
                onPressed: () =>
                    Navigator.pushNamed(context, PlayScreen.ROUTE_NAME),
              ),
            ],
          )
        ],
      ),
    );
  }
}
