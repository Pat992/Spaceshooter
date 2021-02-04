import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as image;
import 'dart:ui' as UI;

class ImagesProvider with ChangeNotifier {
  UI.Image _player;
  List<Enemy> _enemies;

  Future<void> initImages() async {
    _player = await loadUiImage('images/spaceship.png', 100, 100);
    _enemies = [];
    //radius = calculateRandomNum(min: 10, max: 50);
    for (int i = 1; i <= 5; ++i) {
      for (int j = 10; j <= 50; ++j) {
        UI.Image img = await loadUiImage('images/asteroid$i.png', j * 2, j * 2);
        _enemies.add(Enemy(image: img, size: j));
      }
    }
  }

  get player => _player;

  UI.Image getRandomEnemyBySize(int size) {
    _enemies.shuffle();
    UI.Image img;
    for (int i = 0; i < _enemies.length; ++i) {
      if (_enemies[i].size == size) {
        img = _enemies[i].image;
        break;
      }
    }
    return img;
  }

  Future<UI.Image> loadUiImage(
      String imageAssetPath, int height, int width) async {
    final ByteData data = await rootBundle.load(imageAssetPath);
    image.Image baseSizeImg = image.decodePng(data.buffer.asUint8List());
    image.Image resizedImg =
        image.copyResize(baseSizeImg, height: height, width: width);
    UI.Codec codec =
        await UI.instantiateImageCodec(image.encodePng(resizedImg));
    UI.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }
}

class Enemy {
  UI.Image image;
  int size;

  Enemy({this.size, this.image});
}
