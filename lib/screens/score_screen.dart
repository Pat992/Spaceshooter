import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaceshooter/providers/preferences_provider.dart';
import 'package:spaceshooter/widgets/score_list.dart';

class ScoreScreen extends StatelessWidget {
  static const ROUTE_NAME = '/scores';

  @override
  Widget build(BuildContext context) {
    final _scoresProvider =
        Provider.of<PreferenceProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Highscore'),
      ),
      body: ScoreList(_scoresProvider.scores),
    );
  }
}
