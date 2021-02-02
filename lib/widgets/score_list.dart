import 'package:flutter/material.dart';

class ScoreList extends StatelessWidget {
  final List<String> _scores;
  ScoreList(this._scores);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: _scores.length,
        itemBuilder: (ctx, i) {
          var scoreItem = _scores[i].split(':');

          return Card(
            child: ListTile(
              title: Text(scoreItem[0]),
              leading: Text('Platz ${i + 1}'),
              trailing: Text('${scoreItem[1]} Punkte'),
            ),
          );
        },
      ),
    );
  }
}
