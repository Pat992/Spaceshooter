import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensors/sensors.dart';
import 'package:spaceshooter/helper/game_helper.dart';
import 'package:spaceshooter/providers/enemy_provider.dart';
import 'package:spaceshooter/providers/images_provider.dart';
import 'package:spaceshooter/providers/player_provider.dart';
import 'package:spaceshooter/providers/preferences_provider.dart';
import 'package:spaceshooter/widgets/game_field.dart';
import 'package:spaceshooter/widgets/highscore_dialog.dart';
import 'package:spaceshooter/widgets/newgame_dialog.dart';
import 'package:vibration/vibration.dart';

class PlayScreen extends StatefulWidget {
  static const ROUTE_NAME = '/play';
  BuildContext _ctx;

  PlayScreen(this._ctx);

  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> with TickerProviderStateMixin {
  int _lives;
  bool _isGameOver;
  int _score;
  bool _isPaused;
  double _playerMove;
  PlayerProvider _player;
  EnemyProvider _enemy;
  ImagesProvider _images;
  StreamSubscription<AccelerometerEvent> _accelerometerStream;
  Animation<double> _animation;
  AnimationController _controller;
  Animation<double> _movementAnimation;
  AnimationController _movementController;
  GameHelper _gameHelper = GameHelper();

  @override
  void initState() {
    super.initState();
    _lives = 3;
    _score = 0;
    _playerMove = 0;
    _isPaused = false;
    _isGameOver = false;

    _player = Provider.of<PlayerProvider>(context, listen: false);
    _enemy = Provider.of<EnemyProvider>(context, listen: false);
    _images = Provider.of<ImagesProvider>(context, listen: false);

    _gameHelper.initGameObjects(widget._ctx, _player, _enemy, _images);

    _controller =
        AnimationController(vsync: this, duration: Duration(hours: 500));
    _controller.forward();

    _movementController =
        AnimationController(vsync: this, duration: Duration(hours: 500));
    _movementController.forward();

    _animation =
        Tween(begin: -50.0, end: MediaQuery.of(widget._ctx).size.height + 50)
            .animate(_controller)
              ..addListener(() {
                if (_isGameOver) {
                  _accelerometerStream.pause();
                  _controller.stop();
                  showGameOverDialog();
                }
                _enemy.checkSpawnNewEnemy();
                _enemy.checkEnemyOverBorder();
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
                    _isGameOver = loseLife();
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
                          setScore(_score);
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
    _movementAnimation =
        Tween(begin: -50.0, end: MediaQuery.of(widget._ctx).size.height + 50)
            .animate(_movementController)
              ..addListener(() {
                _enemy.moveEnemies();
                _player.moveY(_playerMove);
                _player.moveBullet();
              });
    _accelerometerStream = accelerometerEvents.listen((event) {
      _playerMove = _gameHelper.movePlayer(event.x);
    });
  }

  @override
  void dispose() {
    _accelerometerStream.cancel();
    _controller.dispose();
    _movementController.dispose();
    super.dispose();
  }

  void togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
    _isPaused ? pauseGame() : resumeGame();
  }

  void pauseGame() {
    _accelerometerStream.pause();
    _controller.stop();
    _movementController.stop();
  }

  void resumeGame() {
    _accelerometerStream.resume();
    _controller.forward();
    _movementController.forward();
  }

  void navigateTo(String route) {
    if (route == '') {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.of(context).pushNamed(route);
    }
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
          _lives == 3
              ? Icon(
                  Icons.favorite,
                  color: Colors.red,
                )
              : Icon(
                  Icons.favorite_border,
                  color: Colors.red,
                ),
          _lives >= 2
              ? Icon(
                  Icons.favorite,
                  color: Colors.red,
                )
              : Icon(
                  Icons.favorite_border,
                  color: Colors.red,
                ),
          _lives >= 1
              ? Icon(
                  Icons.favorite,
                  color: Colors.red,
                )
              : Icon(
                  Icons.favorite_border,
                  color: Colors.red,
                ),
          IconButton(
              icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
              onPressed: togglePause),
        ],
      ),
      body: GameField(_player),
    );
  }

  Future<Widget> showGameOverDialog() {
    PreferenceProvider _prefs =
        Provider.of<PreferenceProvider>(context, listen: false);

    return _score > _prefs.getLowestScore()
        ? highscoreDialog(context, _score, navigateTo)
        : newgameDialog(context, navigateTo);
  }
}
