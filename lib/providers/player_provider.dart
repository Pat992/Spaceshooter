import 'package:flutter/material.dart';

class Player with ChangeNotifier {
  double _posX;
  double _posY;
  double _radius;

  Player(this._posY, this._posX, this._radius);

  moveY(double distance) {
    _posY += distance;
    notifyListeners();
  }

  get posY => _posY;

  get posX => _posX;

  get radius => _radius;
}
