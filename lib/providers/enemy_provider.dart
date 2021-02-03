import 'dart:math';

import 'package:flutter/material.dart';

class EnemyProvider with ChangeNotifier {
  double posX;
  double posY;
  double maxX;
  double maxY;
  double radius;
  int lives;

  EnemyProvider() {
    posY = 0;
    posX = 0;
    radius = calculateRandomNum(min: 10, max: 100);
    lives = radius ~/ 10;
  }

  void resetPosition() {
    radius = calculateRandomNum(min: 10, max: 100);
    posY = calculateRandomNum(min: radius, max: maxY);
    lives = radius ~/ 10;
    this.posX = -radius;
  }

  moveX(double distance) {
    if (posX >= maxX) {
      resetPosition();
    } else {
      posX += distance;
    }
    notifyListeners();
  }

  double calculateRandomNum({double min, double max}) {
    Random rand = Random();
    return rand.nextDouble() * (max - min) + min;
  }
}
