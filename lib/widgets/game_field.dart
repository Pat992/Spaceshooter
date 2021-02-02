import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'file:///D:/m335/spaceshooter/lib/providers/enemy_provider.dart';
import 'package:spaceshooter/helper/painter.dart';
import 'file:///D:/m335/spaceshooter/lib/providers/player_provider.dart';

class GameField extends StatefulWidget {
  Player _player;
  Enemy _enemy;
  BuildContext _ctx;
  Function _reduceLives;
  bool _isGameOver;

  GameField(this._isGameOver, this._reduceLives, this._ctx) {
    _enemy = Enemy(MediaQuery.of(_ctx).size.width / 2, 0, 50);
    _player = Player(MediaQuery.of(_ctx).size.width / 2,
        MediaQuery.of(_ctx).size.height - 200, 50);
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
      painter: Painter(widget._player, widget._enemy),
    );
  }
}
