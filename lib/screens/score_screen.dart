import 'package:flutter/material.dart';

class ScoreScreen extends StatelessWidget {
  static const ROUTE_NAME = '/scores';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Highscores'),
      ),
      body: Container(),
    );
  }
}
