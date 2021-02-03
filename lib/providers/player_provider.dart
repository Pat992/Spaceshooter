import 'package:flutter/material.dart';

class PlayerProvider with ChangeNotifier {
  double posX;
  double posY;
  double maxY;
  double radius;

  PlayerProvider() {
    posX = 0;
    posY = 0;
    maxY = 0;
    radius = 10;
  }

  moveY(double distance) {
    if (posY >= maxY - radius && distance > 0)
      return;
    else if (posY <= 0 + radius && distance < 0) return;
    posY += distance;
    notifyListeners();
  }
}