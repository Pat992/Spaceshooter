import 'package:flutter/material.dart';
import 'file:///D:/m335/spaceshooter/lib/providers/enemy_provider.dart';
import 'file:///D:/m335/spaceshooter/lib/providers/player_provider.dart';

class Painter extends CustomPainter {
  Player _player;
  Enemy _enemy;

  Painter(this._player, this._enemy);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(_player.posY, _player.posX), _player.radius, paint);
    canvas.drawCircle(Offset(_enemy.posY, _enemy.posX), _enemy.radius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
