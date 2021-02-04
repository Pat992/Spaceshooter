import 'package:flutter/material.dart';
import 'package:spaceshooter/widgets/game_field.dart';

class PlayScreen extends StatefulWidget {
  static const ROUTE_NAME = '/play';

  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  int _lives;
  bool _isGameOver;
  int _score;

  @override
  void initState() {
    super.initState();
    _lives = 3;
    _score = 0;
    _isGameOver = false;
  }

  void forceRedraw() {
    setState(() {
      _lives = 3;
      _isGameOver = false;
    });
  }

  void setScore(int amount) {
    setState(() {
      _score = amount;
    });
  }

  bool loseLife() {
    setState(() {
      --_lives;
      if (_lives <= 0) {
        _isGameOver = true;
      }
    });
    return _isGameOver;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Score: $_score'),
        actions: [
          _lives == 3 ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
          _lives >= 2 ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
          _lives >= 1 ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
        ],
      ),
      body: GameField(loseLife, context, forceRedraw, setScore),
    );
  }
}
