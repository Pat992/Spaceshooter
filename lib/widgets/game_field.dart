import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensors/sensors.dart';
import 'package:spaceshooter/helper/painter.dart';
import 'package:spaceshooter/helper/game_helper.dart';
import 'package:spaceshooter/providers/enemy_provider.dart';
import 'package:spaceshooter/providers/player_provider.dart';
import 'package:spaceshooter/providers/preferences_provider.dart';
import 'package:spaceshooter/screens/play_screen.dart';
import 'package:spaceshooter/screens/score_screen.dart';
import 'package:vibration/vibration.dart';

class GameField extends StatefulWidget {
  final BuildContext _ctx;
  final Function _reduceLives;
  final Function _forceRedraw;

  GameField(this._reduceLives, this._ctx, this._forceRedraw);

  @override
  _GameFieldState createState() => _GameFieldState();
}

class _GameFieldState extends State<GameField> with TickerProviderStateMixin {
  PlayerProvider _player;
  EnemyProvider _enemy;
  StreamSubscription<AccelerometerEvent> accelerometerStream;
  Animation<double> _animation;
  AnimationController _controller;
  GameHelper _gameHelper = GameHelper();
  double _playerMove;
  bool _isGameOver;
  int _score;
  double _speed;

  @override
  void initState() {
    super.initState();
    _playerMove = 0;
    _score = 0;
    _speed = 1;
    _isGameOver = false;

    _player = Provider.of<PlayerProvider>(widget._ctx, listen: false);
    _enemy = Provider.of<EnemyProvider>(widget._ctx, listen: false);

    _player.posY = MediaQuery.of(widget._ctx).size.width / 2;
    _player.posX = MediaQuery.of(widget._ctx).size.height - 200;
    _player.maxY = MediaQuery.of(widget._ctx).size.width - _player.radius;
    _player.maxX = MediaQuery.of(widget._ctx).size.height + _player.radius;
    _player.bullets = [];

    _enemy.posX = -_enemy.radius;
    _enemy.maxX = MediaQuery.of(widget._ctx).size.height + _enemy.radius;
    _enemy.maxY = MediaQuery.of(widget._ctx).size.width - _enemy.radius;
    _enemy.posY =
        _enemy.calculateRandomNum(min: _enemy.radius, max: _enemy.maxY);

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
                  _player.moveBullet();
                  if (_gameHelper.checkForCollision(
                      obj1Size: _player.radius,
                      obj1X: _player.posX,
                      obj1Y: _player.posY,
                      obj2Size: _enemy.radius,
                      obj2X: _enemy.posX,
                      obj2Y: _enemy.posY)) {
                    Vibration.vibrate(duration: 100);
                    _isGameOver = widget._reduceLives();
                    _enemy.resetPosition();
                  }
                  if (_isGameOver) {
                    accelerometerStream.pause();
                    _controller.stop();
                    showGameOverDialog();
                  }
                });
              });
    accelerometerStream = accelerometerEvents.listen((event) {
      _playerMove = _gameHelper.movePlayer(event.x);
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

    double enemyStartX = _enemy.posX - _enemy.radius;
    double enemyEndX = _enemy.posX + _enemy.radius;
    double enemyStartY = _enemy.posY - _enemy.radius;
    double enemyEndY = _enemy.posY + _enemy.radius;

    if (enemyStartY <= playerEndY &&
        enemyEndY >= playerStartY &&
        enemyStartX <= playerEndX &&
        enemyEndX >= playerStartX) {
      Vibration.vibrate(duration: 100);
      _isGameOver = widget._reduceLives();
      _enemy.resetPosition();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _player.shoot,
      child: CustomPaint(
        size: MediaQuery.of(context).size,
        painter: Painter(context),
      ),
    );
  }

  Future<Widget> showGameOverDialog() {
    PreferenceProvider _prefs =
        Provider.of<PreferenceProvider>(context, listen: false);

    final _scoreController = TextEditingController();
    return _score > _prefs.getLowestScore()
        ? showDialog(
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
                    _prefs.addScore(
                        name: _scoreController.text, newScore: _score);
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
          )
        : showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Game Over'),
              content: Text('Play Again?'),
              actions: <Widget>[
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: not a great way to reload page...
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.pushNamed(context, PlayScreen.ROUTE_NAME);
                  },
                  icon: Icon(Icons.save),
                  label: Text(
                    'OK',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  icon: Icon(Icons.save),
                  label: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
          );
  }
}
