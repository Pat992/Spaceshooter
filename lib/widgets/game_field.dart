import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensors/sensors.dart';
import 'package:spaceshooter/helper/painter.dart';
import 'package:spaceshooter/helper/game_helper.dart';
import 'package:spaceshooter/providers/enemy_provider.dart';
import 'package:spaceshooter/providers/images_provider.dart';
import 'package:spaceshooter/providers/player_provider.dart';
import 'package:spaceshooter/providers/preferences_provider.dart';
import 'package:spaceshooter/screens/play_screen.dart';
import 'package:spaceshooter/screens/score_screen.dart';
import 'package:vibration/vibration.dart';

class GameField extends StatefulWidget {
  final BuildContext _ctx;
  final Function _reduceLives;
  final Function _forceRedraw;
  final Function(int) _setScore;

  GameField(this._reduceLives, this._ctx, this._forceRedraw, this._setScore);

  @override
  _GameFieldState createState() => _GameFieldState();
}

class _GameFieldState extends State<GameField> with TickerProviderStateMixin {
  PlayerProvider _player;
  EnemyProvider _enemy;
  ImagesProvider _images;
  StreamSubscription<AccelerometerEvent> accelerometerStream;
  Animation<double> _animation;
  AnimationController _controller;
  GameHelper _gameHelper = GameHelper();
  double _playerMove;
  bool _isGameOver;
  int _score;

  @override
  void initState() {
    super.initState();
    _playerMove = 0;
    _score = 0;
    _isGameOver = false;

    _player = Provider.of<PlayerProvider>(widget._ctx, listen: false);
    _enemy = Provider.of<EnemyProvider>(widget._ctx, listen: false);
    _images = Provider.of<ImagesProvider>(widget._ctx, listen: false);

    _player.posY = MediaQuery.of(widget._ctx).size.width / 2;
    _player.posX = MediaQuery.of(widget._ctx).size.height - 200;
    _player.maxY = MediaQuery.of(widget._ctx).size.width - _player.radius;
    _player.maxX = MediaQuery.of(widget._ctx).size.height + _player.radius;
    _player.bullets = [];

    _enemy.maxX = MediaQuery.of(widget._ctx).size.height;
    _enemy.maxY = MediaQuery.of(widget._ctx).size.width;
    _enemy.startEnemiesPosition();

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
                  _enemy.checkSpawnNewEnemy();
                  _enemy.checkEnemyOverBorder();
                  _enemy.moveEnemies();
                  _player.moveY(_playerMove);
                  _player.moveBullet();
                  if (_isGameOver) {
                    accelerometerStream.pause();
                    _controller.stop();
                    showGameOverDialog();
                  }
                  for (int i = 0; i < _enemy.enemies.length; ++i) {
                    bool toRemoveAfterLoop = false;
                    if (_gameHelper.checkForCollision(
                        obj1Size: _player.radius,
                        obj1X: _player.posX,
                        obj1Y: _player.posY,
                        obj2Size: _enemy.enemies[i].radius,
                        obj2X: _enemy.enemies[i].posX,
                        obj2Y: _enemy.enemies[i].posY)) {
                      Vibration.vibrate(duration: 400);
                      _isGameOver = widget._reduceLives();
                      toRemoveAfterLoop = true;
                    }
                    if (_player.bullets.isNotEmpty) {
                      for (int bi = 0; bi < _player.bullets.length; ++bi) {
                        if (_gameHelper.checkForCollision(
                            obj1Size: _player.bullets[bi]['radius'],
                            obj1X: _player.bullets[bi]['posX'],
                            obj1Y: _player.bullets[bi]['posY'],
                            obj2Size: _enemy.enemies[i].radius,
                            obj2X: _enemy.enemies[i].posX,
                            obj2Y: _enemy.enemies[i].posY)) {
                          int destroyed = _enemy.onHitEnemy(i);
                          _player.onHitTarget(bi);
                          if (destroyed > 0) {
                            Vibration.vibrate(duration: 50);
                            _score += destroyed;
                            widget._setScore(_score);
                            toRemoveAfterLoop = false;
                          }
                        }
                      }
                    }
                    if (toRemoveAfterLoop) {
                      _enemy.removeEnemyAtIndex(i);
                    }
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
    _animation.removeListener(() {});
    super.dispose();
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
