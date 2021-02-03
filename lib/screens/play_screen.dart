import 'package:flutter/material.dart';
import 'package:spaceshooter/widgets/game_field.dart';

class PlayScreen extends StatefulWidget {
  static const ROUTE_NAME = '/play';

  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  int _lives = 3;
  bool _isGameOver = false;

  void loseLife() {
    setState(() {
      --_lives;
      if (_lives <= 0) {
        _isGameOver = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Punkte: '),
        actions: [
          _lives == 3 ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
          _lives >= 2 ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
          _lives >= 1 ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
        ],
      ),
      body: GameField(_isGameOver, loseLife, context),
    );
  }
}
