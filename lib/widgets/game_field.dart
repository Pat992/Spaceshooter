import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensors/sensors.dart';
import 'package:spaceshooter/helper/painter.dart';
import 'package:spaceshooter/providers/enemy_provider.dart';
import 'package:spaceshooter/providers/player_provider.dart';
import 'package:vibration/vibration.dart';

class GameField extends StatefulWidget {
  BuildContext _ctx;
  Function _reduceLives;
  bool _isGameOver;
  PlayerProvider _player;
  EnemyProvider _enemy;

  GameField(this._isGameOver, this._reduceLives, this._ctx) {
    _player = Provider.of<PlayerProvider>(_ctx, listen: false);
    _enemy = Provider.of<EnemyProvider>(_ctx, listen: false);

    _player.posY = MediaQuery.of(_ctx).size.width / 2;
    _player.posX = MediaQuery.of(_ctx).size.height - 200;
    _player.maxY = MediaQuery.of(_ctx).size.width - _player.radius;

    _enemy.posY = MediaQuery.of(_ctx).size.width / 2;
    _enemy.posX = -_enemy.radius;
    _enemy.maxX = MediaQuery.of(_ctx).size.height + _enemy.radius;
  }
  @override
  _GameFieldState createState() => _GameFieldState();
}

class _GameFieldState extends State<GameField> with TickerProviderStateMixin {
  StreamSubscription<AccelerometerEvent> accelerometerStream;
  Animation<double> _animation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 15000));
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
                  //print(_animation.value);
                  widget._enemy.moveX(1);
                  checkForCollision();
                });
              });
    accelerometerStream = accelerometerEvents.listen((event) {
      widget._player.moveY(0);
    });
  }

  @override
  void dispose() {
    accelerometerStream.cancel();
    _controller.dispose();
    super.dispose();
  }

  void checkForCollision() {
    double playerStartX = widget._player.posX - widget._player.radius;
    double playerEndX = widget._player.posX + widget._player.radius;
    double playerStartY = widget._player.posY - widget._player.radius;
    double playerEndY = widget._player.posY + widget._player.radius;

    double enemyStartX =
        widget._enemy.posX - widget._enemy.radius + (widget._enemy.radius / 2);
    double enemyEndX =
        widget._enemy.posX + widget._enemy.radius - (widget._enemy.radius / 2);
    double enemyStartY =
        widget._enemy.posY - widget._enemy.radius + (widget._enemy.radius / 2);
    double enemyEndY =
        widget._enemy.posY + widget._enemy.radius - (widget._enemy.radius / 2);

    if (enemyStartY <= playerEndY &&
        enemyEndY >= playerStartY &&
        enemyStartX <= playerEndX &&
        enemyEndX >= playerStartX) {
      Vibration.vibrate(duration: 100);
      widget._reduceLives();
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
