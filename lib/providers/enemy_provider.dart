import 'dart:math';

import 'package:flutter/material.dart';

class EnemyProvider with ChangeNotifier {
  double posX;
  double posY;
  double maxX;
  double maxY;
  double radius;
  int lives;
  int points;
  int speed;

  EnemyProvider() {
    posY = 0;
    posX = 0;
    radius = calculateRandomNum(min: 10, max: 100);
    lives = radius ~/ 10;
    points = lives;
    speed = calculateRandomNum(min: 1, max: 2).toInt();
  }

  int onShootedAt() {
    --lives;
    if (lives <= 0) {
      resetPosition();
      return points;
    }
    return 0;
  }

  void resetPosition() {
    radius = calculateRandomNum(min: 10, max: 100);
    posY = calculateRandomNum(min: radius, max: maxY);
    speed = calculateRandomNum(min: 1, max: 2).toInt();
    lives = radius ~/ 10;
    this.posX = -radius;
  }

  moveX(double distance) {
    if (posX >= maxX) {
      resetPosition();
    } else {
      posX += speed;
    }
    notifyListeners();
  }

  double calculateRandomNum({double min, double max}) {
    Random rand = Random();
    return rand.nextDouble() * (max - min) + min;
  }
}
