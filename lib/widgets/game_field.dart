import 'package:flutter/material.dart';
import 'package:spaceshooter/helper/painter.dart';
import 'package:spaceshooter/providers/player_provider.dart';

class GameField extends StatelessWidget {
  final PlayerProvider player;
  GameField(this.player);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: player.shoot,
      child: CustomPaint(
        size: MediaQuery.of(context).size,
        painter: Painter(context),
      ),
    );
  }
}
