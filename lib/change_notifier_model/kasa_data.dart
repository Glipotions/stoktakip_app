import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KasaData with ChangeNotifier {
  int? _kasaId;
  String? _kasaAdi;
  static SharedPreferences _sharedPref = SharedPreferences as SharedPreferences;

  void kasaSec(int kasaId, String kasaAdi) {
    // _selectedThemeData = selected ? greenTheme : redTheme;
    _kasaAdi = kasaAdi;
    _kasaId = kasaId;
    saveKasaToSharedPref(kasaId, kasaAdi);
    notifyListeners();
  }

  int? get kasaId => _kasaId;
  String? get kasaAdi => _kasaAdi;

  // ThemeData get selectedThemeData => _isGreen ? greenTheme : redTheme;

  Future<void> createPrefObject() async {
    _sharedPref = await SharedPreferences.getInstance();
  }

  void saveKasaToSharedPref(int value, String kasaAdi) {
    _sharedPref.setInt('kasaId', value);
    _sharedPref.setString('kasaAdi', kasaAdi);
  }

  void loadKasaToSharedPref() {
    _kasaId = _sharedPref.getInt('kasaId') ?? -1;
    _kasaAdi = _sharedPref.getString('kasaAdi') ?? "";
  }
}
