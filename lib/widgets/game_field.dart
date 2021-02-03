import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensors/sensors.dart';
import 'package:spaceshooter/helper/painter.dart';
import 'package:spaceshooter/helper/game_helper.dart';
import 'package:spaceshooter/providers/enemy_provider.dart';
import 'package:spaceshooter/providers/player_provider.dart';
import 'package:spaceshooter/providers/preferences_provider.dart';
import 'package:spaceshooter/screens/score_screen.dart';
import 'package:vibration/vibration.dart';

class GameField extends StatefulWidget {
  final BuildContext _ctx;
  final Function _reduceLives;

  GameField(this._reduceLives, this._ctx);

  @override
  _GameFieldState createState() => _GameFieldState();
}

class _GameFieldState extends State<GameField> with TickerProviderStateMixin {
  PlayerProvider _player;
  EnemyProvider _enemy;
  StreamSubscription<AccelerometerEvent> accelerometerStream;
  Animation<double> _animation;
  AnimationController _controller;
  PlayerHelper _playerMovement = PlayerHelper();
  double _playerMove = 0;
  bool _isGameOver = false;
  int _score = 0;
  double _speed = 1;

  @override
  void initState() {
    _player = Provider.of<PlayerProvider>(widget._ctx, listen: false);
    _enemy = Provider.of<EnemyProvider>(widget._ctx, listen: false);

    _player.posY = MediaQuery.of(widget._ctx).size.width / 2;
    _player.posX = MediaQuery.of(widget._ctx).size.height - 200;
    _player.maxY = MediaQuery.of(widget._ctx).size.width - _player.radius;

    _enemy.posX = -_enemy.radius;
    _enemy.maxX = MediaQuery.of(widget._ctx).size.height + _enemy.radius;
    _enemy.maxY = MediaQuery.of(widget._ctx).size.width - _enemy.radius;
    _enemy.posY =
        _enemy.calculateRandomPos(min: _enemy.radius, max: _enemy.maxY);

    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(hours: 500));
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
      }
    });
    _animation =
        Tween(begin: -50.0, end: MediaQuery.of(widget._ctx).size.height + 50)
            .animate(_controller)
              ..addListener(() {
                setState(() {
                  _enemy.moveX(_speed);
                  _player.moveY(_playerMove);
                  checkForCollision();
                  if (_isGameOver) {
                    accelerometerStream.pause();
                    _controller.stop();
                    showGameOverDialog(widget._ctx, _score);
                  }
                });
              });
    accelerometerStream = accelerometerEvents.listen((event) {
      _playerMove = _playerMovement.movePlayer(event.x);
    });
  }

  @override
  void dispose() {
    accelerometerStream.cancel();
    _controller.dispose();
    super.dispose();
  }

  void checkForCollision() {
    double playerStartX = _player.posX - _player.radius;
    double playerEndX = _player.posX + _player.radius;
    double playerStartY = _player.posY - _player.radius;
    double playerEndY = _player.posY + _player.radius;

    double enemyStartX = _enemy.posX - _enemy.radius + (_enemy.radius / 2);
    double enemyEndX = _enemy.posX + _enemy.radius - (_enemy.radius / 2);
    double enemyStartY = _enemy.posY - _enemy.radius + (_enemy.radius / 2);
    double enemyEndY = _enemy.posY + _enemy.radius - (_enemy.radius / 2);

    if (enemyStartY <= playerEndY &&
        enemyEndY >= playerStartY &&
        enemyStartX <= playerEndX &&
        enemyEndX >= playerStartX) {
      Vibration.vibrate(duration: 100);
      _isGameOver = widget._reduceLives();
      _enemy.posX = -50;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: MediaQuery.of(context).size,
      painter: Painter(context),
    );
  }
}

Future<Widget> showGameOverDialog(BuildContext context, int score) {
  PreferenceProvider _prefs =
      Provider.of<PreferenceProvider>(context, listen: false);

  final _scoreController = TextEditingController();
  return showDialog(
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
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.pushNamed(context, ScoreScreen.ROUTE_NAME);
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