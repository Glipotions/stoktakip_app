import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KdvData with ChangeNotifier {
  double _kdv = 8;
  static SharedPreferences _sharedPref = SharedPreferences as SharedPreferences;

  void kdvSec(double kdv) {
    // _selectedThemeData = selected ? greenTheme : redTheme;
    _kdv = kdv;
    saveKdvToSharedPref(kdv);
    notifyListeners();
  }

  double get kdv => _kdv;
  // ThemeData get selectedThemeData => _isGreen ? greenTheme : redTheme;

  Future<void> createPrefObject() async {
    _sharedPref = await SharedPreferences.getInstance();
  }

  void saveKdvToSharedPref(double value) {
    _sharedPref.setDouble('kdvOrani', value);
  }

  void loadKdvToSharedPref() {
    _kdv = _sharedPref.getDouble('kdvOrani') ?? 8;
  }
}
