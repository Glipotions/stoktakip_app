import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KdvData with ChangeNotifier {
  int _kdv = 8;
  static SharedPreferences _sharedPref = SharedPreferences as SharedPreferences;

  void kdvSec(int kdv) {
    // _selectedThemeData = selected ? greenTheme : redTheme;
    _kdv = kdv;
    saveKdvToSharedPref(kdv);
    notifyListeners();
  }

  int get kdv => _kdv;
  // ThemeData get selectedThemeData => _isGreen ? greenTheme : redTheme;

  Future<void> createPrefObject() async {
    _sharedPref = await SharedPreferences.getInstance();
  }

  void saveKdvToSharedPref(int value) {
    _sharedPref.setInt('kdvOrani', value);
  }

  void loadKdvToSharedPref() {
    _kdv = _sharedPref.getInt('kdvOrani') ?? 8;
  }
}
