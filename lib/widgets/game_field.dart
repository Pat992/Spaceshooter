import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensors/sensors.dart';
import 'package:spaceshooter/helper/painter.dart';
import 'package:spaceshooter/providers/enemy_provider.dart';
import 'package:spaceshooter/providers/player_provider.dart';

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

class _GameFieldState extends State<GameField> {
  StreamSubscription<AccelerometerEvent> accelerometerStream;
  @override
  void initState() {
    super.initState();
    accelerometerStream = accelerometerEvents.listen((event) {
      widget._player.moveY(event.x);
      widget._enemy.moveX(10);
    });
  }

  @override
  void dispose() {
    accelerometerStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: MediaQuery.of(context).size,
      painter: Painter(context),
    );
  }
}
