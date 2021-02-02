import 'package:flutter/material.dart';

class EnemyProvider with ChangeNotifier {
  double posX;
  double posY;
  double maxX;
  double radius;

  EnemyProvider() {
    posY = 0;
    posX = 0;
    radius = 10;
  }

  moveX(double distance) {
    if (posX >= maxX) {
      posX = -radius;
    } else {
      posX += distance;
    }
    notifyListeners();
  }
}
