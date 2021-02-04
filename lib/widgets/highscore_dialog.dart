import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaceshooter/providers/preferences_provider.dart';
import 'package:spaceshooter/screens/score_screen.dart';

Future<Widget> highscoreDialog(
    BuildContext context, int score, Function(String) navigate) {
  final _scoreController = TextEditingController();
  PreferenceProvider _prefs =
      Provider.of<PreferenceProvider>(context, listen: false);
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Game Over'),
      content: Text('New Score, input your name:'),
      actions: <Widget>[
        Container(
          width: 200,
          child: TextField(
            controller: _scoreController,
          ),
        ),
        TextButton.icon(
          onPressed: () {
            if (_scoreController.text.trim().isEmpty) return;
            _prefs.addScore(name: _scoreController.text, newScore: score);
            navigate(ScoreScreen.ROUTE_NAME);
          },
          icon: Icon(Icons.save),
          label: Text(
            'Save',
            style: TextStyle(color: Colors.black),
          ),
        )
      ],
    ),
  );
}
