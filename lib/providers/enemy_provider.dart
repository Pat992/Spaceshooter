import 'package:flutter/material.dart';

class Enemy with ChangeNotifier {
  double _posX;
  double _posY;
  double _radius;

  Enemy(this._posY, this._posX, this._radius);

  moveX(double distance) {
    _posX += distance;
    notifyListeners();
  }

  get posY => _posY;

  get posX => _posX;

  get radius => _radius;
}
