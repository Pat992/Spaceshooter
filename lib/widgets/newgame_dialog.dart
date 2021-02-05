import 'package:flutter/material.dart';
import 'package:spaceshooter/screens/play_screen.dart';

Future<Widget> newgameDialog(BuildContext context, Function navigation) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Game Over'),
      content: Text('Play Again?'),
      actions: <Widget>[
        ElevatedButton.icon(
          onPressed: () {
            // TODO: not a great way to reload page...
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.pushNamed(context, PlayScreen.ROUTE_NAME);
          },
          icon: Icon(Icons.play_arrow),
          label: Text(
            'OK',
            style: TextStyle(color: Colors.black),
          ),
        ),
        TextButton.icon(
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          icon: Icon(Icons.cancel_outlined),
          label: Text(
            'Cancel',
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    ),
  );
}
