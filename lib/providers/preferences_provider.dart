import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceProvider with ChangeNotifier {
  SharedPreferences _prefs;
  List<String> _scores;

  Future<void> initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _scores = _prefs.getStringList('scores') ?? [];
  }

  get scores => _scores;

  String getLowestScore() => _scores[_scores.length - 1];

  Future<void> addScore({String name, int newScore}) {
    for (int i = 0; i < _scores.length; ++i) {
      var entry = _scores[i].split(':');
      if (newScore <= int.parse(entry[1])) {
        _scores[i] = '$name:$newScore';
        break;
      }
    }
    notifyListeners();
  }
}
