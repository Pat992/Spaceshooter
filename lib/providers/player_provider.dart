import 'package:flutter/material.dart';

class PlayerProvider with ChangeNotifier {
  double posX;
  double posY;
  double maxX;
  double maxY;
  double radius;
  int shooting;
  List<Map<String, double>> bullets;

  PlayerProvider() {
    posX = 0;
    posY = 0;
    maxY = 0;
    maxX = 0;
    radius = 10;
    shooting = 20;
    bullets = [];
  }

  void shoot() {
    if (shooting <= 0) {
      bullets.add({'radius': 5, 'posX': posX - radius, 'posY': posY});
      shooting = 20;
    }
    notifyListeners();
  }

  onHitTarget(int index) {
    bullets.removeAt(index);
  }

  void moveBullet() {
    --shooting;
    if (bullets.isNotEmpty) {
      for (int i = 0; i < bullets.length; ++i) {
        if (bullets[i]['posX'] <= -radius) {
          bullets.removeAt(i);
        } else {
          bullets[i]['posX'] -= 10;
        }
      }
    }
  }

  moveY(double distance) {
    if (posY >= maxY - radius && distance > 0)
      return;
    else if (posY <= 0 + radius && distance < 0) return;
    posY += distance;
    notifyListeners();
  }
}
