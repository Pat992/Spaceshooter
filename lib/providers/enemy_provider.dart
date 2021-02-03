import 'dart:math';

import 'package:flutter/material.dart';

class EnemyProvider with ChangeNotifier {
  double posX;
  double posY;
  double maxX;
  double maxY;
  double radius;

  EnemyProvider() {
    posY = 0;
    posX = 0;
    radius = 10;
  }

  moveX(double distance) {
    if (posX >= maxX) {
      posX = -radius;
      posY = calculateRandomPos(min: radius, max: maxY);
    } else {
      posX += distance;
    }
    notifyListeners();
  }

  double calculateRandomPos({double min, double max}) {
    Random rand = Random();
    return rand.nextDouble() * (max - min) + min;
  }
}
