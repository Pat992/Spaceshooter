import 'package:flutter/material.dart';
import 'package:spaceshooter/widgets/game_field.dart';

class PlayScreen extends StatelessWidget {
  static const ROUTE_NAME = '/play';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Punkte: '),
        actions: [
          Icon(Icons.favorite),
          Icon(Icons.favorite),
          Icon(Icons.favorite)
        ],
      ),
      body: GameField(),
    );
  }
}
