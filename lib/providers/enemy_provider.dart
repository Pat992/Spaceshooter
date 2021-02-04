import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:ui' as UI;
import 'package:spaceshooter/providers/images_provider.dart';

class EnemyProvider with ChangeNotifier {
  double maxX;
  double maxY;
  double radius;
  int lives;
  int points;
  double maxSpeed;
  double spawnRate;
  List<Enemy> enemies;
  ImagesProvider imagesProvider;

  EnemyProvider(this.imagesProvider) {
    startEnemiesPosition();
  }

  void startEnemiesPosition() {
    spawnRate = 150;
    maxSpeed = 2;
    enemies = [];
  }

  void checkSpawnNewEnemy() {
    bool isSpawnEnemy =
        calculateRandomDouble(min: 1, max: spawnRate).toInt() == 4;
    if (enemies.isEmpty || isSpawnEnemy) {
      radius = calculateRandomInt(min: 10, max: 50).toDouble();
      enemies.add(
        Enemy(
          radius: radius,
          speed: calculateRandomDouble(min: maxSpeed / 2, max: maxSpeed),
          posX: -radius,
          posY: calculateRandomDouble(min: radius, max: maxY - radius),
          img: imagesProvider.getRandomEnemyBySize(radius.toInt()),
        ),
      );
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
      spawnRate -= 2;
      maxSpeed += 0.1;
      removeEnemyAtIndex(index);
      return points;
    }
    return 0;
  }

  void removeEnemyAtIndex(int index) {
    enemies.removeAt(index);
    notifyListeners();
  }

  void moveEnemies() {
    enemies.forEach((enemy) {
      enemy.moveEnemy();
    });
    notifyListeners();
  }

  double calculateRandomDouble({double min, double max}) {
    Random rand = Random();
    return rand.nextDouble() * (max - min) + min;
  }

  int calculateRandomInt({int min, int max}) {
    Random rand = Random();
    return rand.nextInt(max - min) + min;
  }
}

class Enemy {
  double posX;
  double posY;
  double radius;
  int lives;
  int points;
  double speed;
  UI.Image img;

  Enemy({this.radius, this.posX, this.posY, this.speed, this.img}) {
    lives = radius ~/ 10;
    points = lives;
  }

  void moveEnemy() {
    posX += speed;
  }
}
