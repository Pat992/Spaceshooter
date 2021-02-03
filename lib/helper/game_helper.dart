import 'dart:math';

class PlayerHelper {
  double movePlayer(double tilt) {
    if (tilt >= 8) {
      return -10;
    } else if (tilt >= 5) {
      return -5;
    } else if (tilt >= 3) {
      return -3;
    } else if (tilt >= 1) {
      return -1;
    } else if (tilt <= -8) {
      return 10;
    } else if (tilt <= -5) {
      return 5;
    } else if (tilt <= -3) {
      return 3;
    } else if (tilt <= -1) {
      return 1;
    } else {
      return 0;
    }
  }
}
