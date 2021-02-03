import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaceshooter/providers/enemy_provider.dart';
import 'package:spaceshooter/providers/player_provider.dart';

class Painter extends CustomPainter {
  BuildContext _ctx;
  PlayerProvider _player;
  EnemyProvider _enemy;

  Painter(this._ctx) {
    _player = Provider.of<PlayerProvider>(_ctx);
    _enemy = Provider.of<EnemyProvider>(_ctx);
  }

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(_player.posY, _player.posX), _player.radius, paint);
    // canvas.drawCircle(Offset(_enemy.posY, _enemy.posX), _enemy.radius, paint);

    if (_player.bullets.isNotEmpty) {
      _player.bullets.forEach((bullet) {
        canvas.drawCircle(
            Offset(bullet['posY'], bullet['posX']), bullet['radius'], paint);
      });
    }

    if (_enemy.enemies.isNotEmpty) {
      _enemy.enemies.forEach((enemy) {
        canvas.drawCircle(Offset(enemy.posY, enemy.posX), enemy.radius, paint);
      });
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
