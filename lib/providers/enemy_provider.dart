import 'dart:math';

import 'package:flutter/material.dart';

class EnemyProvider with ChangeNotifier {
  double maxX;
  double maxY;
  double radius;
  int lives;
  int points;
  int maxSpeed;
  double spawnRate;
  List<Enemy> enemies = [];

  EnemyProvider() {
    spawnRate = 150;
  }

  void spawnEnemy(double radius, double posX, double posY) {
    enemies.add(Enemy(radius: radius, posX: posX, posY: posY, speed: 1));
    notifyListeners();
  }

  void checkSpawnNewEnemy() {
    bool isSpawnEnemy = calculateRandomNum(min: 1, max: spawnRate).toInt() == 4;
    if (enemies.isEmpty || isSpawnEnemy) {
      radius = calculateRandomNum(min: 10, max: 50);
      enemies.add(Enemy(
          radius: radius,
          speed: calculateRandomNum(min: 1, max: 2),
          posX: -radius,
          posY: calculateRandomNum(min: radius, max: maxY - radius)));
    }
  }

  checkEnemyOverBorder() {
    for (int i = 0; i < enemies.length; ++i) {
      if (enemies[i].posX >= maxX) {
        removeEnemyAtIndex(i);
      }
    }
    notifyListeners();
  }

  int onHitEnemy(int index) {
    enemies[index].lives--;
    if (enemies[index].lives <= 0) {
      int points = enemies[index].points;
      removeEnemyAtIndex(index);
      return points;
    }
    return 0;
  }

  void removeEnemyAtIndex(int index) {
    print(index);
    print(enemies);
    enemies.removeAt(index);
    notifyListeners();
  }

  void moveEnemies() {
    enemies.forEach((enemy) {
      enemy.moveEnemy();
    });
    notifyListeners();
  }

  double calculateRandomNum({double min, double max}) {
    Random rand = Random();
    return rand.nextDouble() * (max - min) + min;
  }
}

class Enemy {
  double posX;
  double posY;
  double radius;
  int lives;
  int points;
  double speed;

  Enemy({this.radius, this.posX, this.posY, this.speed}) {
    lives = radius ~/ 10;
    points = lives;
  }

  void moveEnemy() {
    posX += speed;
  }
}
