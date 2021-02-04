import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaceshooter/providers/enemy_provider.dart';
import 'package:spaceshooter/providers/images_provider.dart';
import 'package:spaceshooter/providers/player_provider.dart';
import 'dart:ui' as UI;

class Painter extends CustomPainter {
  BuildContext _ctx;
  PlayerProvider _player;
  EnemyProvider _enemy;
  ImagesProvider _images;

  Painter(this._ctx) {
    _player = Provider.of<PlayerProvider>(_ctx);
    _enemy = Provider.of<EnemyProvider>(_ctx);
    _images = Provider.of<ImagesProvider>(_ctx);
  }

  @override
  void paint(Canvas canvas, Size size) {
    _images.getRandomEnemyBySize(10);
    var paint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(_player.posY, _player.posX), _player.radius, paint);

    if (_enemy.enemies.isNotEmpty) {
      _enemy.enemies.forEach((enemy) {
        canvas.drawCircle(Offset(enemy.posY, enemy.posX), enemy.radius, paint);
        try {
          paint.color = Colors.red;
          canvas.drawImage(
              enemy.img,
              Offset(enemy.posY - enemy.radius, enemy.posX - enemy.radius),
              paint);
          paint.color = Colors.transparent;
        } catch (Exception) {
          print("Error getting image");
        }
      });
    }
    paint.color = Colors.red;

    canvas.drawImage(
        _images.player,
        Offset(_player.posY - _player.radius * 2,
            _player.posX - _player.radius * 1.5),
        paint);

    if (_player.bullets.isNotEmpty) {
      _player.bullets.forEach((bullet) {
        canvas.drawCircle(
            Offset(bullet['posY'], bullet['posX']), bullet['radius'], paint);
      });
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
