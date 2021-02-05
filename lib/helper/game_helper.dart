import 'package:flutter/material.dart';
import 'package:spaceshooter/providers/enemy_provider.dart';
import 'package:spaceshooter/providers/images_provider.dart';
import 'package:spaceshooter/providers/player_provider.dart';

class GameHelper {
  PlayerProvider _player;
  EnemyProvider _enemy;

  void initGameObjects(BuildContext context, PlayerProvider player,
      EnemyProvider enemy, ImagesProvider images) {
    _player = player;
    _enemy = enemy;

    _player.posY = MediaQuery.of(context).size.width / 2;
    _player.posX = MediaQuery.of(context).size.height - 200;
    _player.maxY = MediaQuery.of(context).size.width - _player.radius;
    _player.maxX = MediaQuery.of(context).size.height + _player.radius;
    _player.bullets = [];

    _enemy.maxX = MediaQuery.of(context).size.height;
    _enemy.maxY = MediaQuery.of(context).size.width;
    _enemy.startEnemiesPosition();
  }

  double movePlayer(double tilt) {
    if (tilt >= 8) {
      return -10;
    } else if (tilt >= 5) {
      return -5;
    } else if (tilt >= 3) {
      return -3;
    } else if (tilt >= 1) {
      return -1;
    } else if (tilt <= -8) {
      return 10;
    } else if (tilt <= -5) {
      return 5;
    } else if (tilt <= -3) {
      return 3;
    } else if (tilt <= -1) {
      return 1;
    } else {
      return 0;
    }
  }

  bool checkForCollision(
      {double obj1Size,
      double obj1X,
      double obj1Y,
      double obj2Size,
      double obj2X,
      double obj2Y}) {
    double obj1StartX = obj1X - obj1Size;
    double obj1EndX = obj1X + obj1Size;
    double obj1StartY = obj1Y - obj1Size;
    double obj1EndY = obj1Y + obj1Size;

    double obj2StartX = obj2X - obj2Size;
    double obj2EndX = obj2X + obj2Size;
    double obj2StartY = obj2Y - obj2Size;
    double obj2EndY = obj2Y + obj2Size;

    if (obj2StartY <= obj1EndY &&
        obj2EndY >= obj1StartY &&
        obj2StartX <= obj1EndX &&
        obj2EndX >= obj1StartX) {
      return true;
    }
    return false;
  }
}
