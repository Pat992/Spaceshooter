import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceProvider with ChangeNotifier {
  SharedPreferences _prefs;
  List<String> _scores;

  Future<void> initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _scores = _prefs.getStringList('scores') ?? [];
    print(_scores);

    if (_scores.isEmpty || _scores.length == 0) {
      for (int i = 0; i < 10; ++i) {
        _scores.add('Noname:0');
      }
    }
  }

  get scores => _scores;

  int getLowestScore() => int.parse(_scores[_scores.length - 1].split(':')[1]);

  void addScore({String name, int newScore}) {
    for (int i = 0; i < _scores.length; ++i) {
      var entry = _scores[i].split(':');
      if (newScore >= int.parse(entry[1])) {
        _scores[i] = '$name:$newScore';
        break;
      }
    }
    _prefs.setStringList('scores', _scores);
    notifyListeners();
  }
}
