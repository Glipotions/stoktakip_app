import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stoktakip_app/functions/const_entities.dart';
import 'package:stoktakip_app/model/alinan_siparis/alinan_siparis_bilgileri.dart';

class AlinanSiparisBilgileriData with ChangeNotifier {
  String? _hostAdi;
  String? _ip;
  static SharedPreferences _prefs = SharedPreferences as SharedPreferences;

  void hostSec(String hostAdi, String ip) {
    // _selectedThemeData = selected ? greenTheme : redTheme;
    _hostAdi = hostAdi;
    _ip = ip;
    notifyListeners();
  }

  String? get ip => _ip;
  String? get hostAdi => _hostAdi;

  Future<void> createPrefObject() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveListToSharedPref(List<AlinanSiparisBilgileri> tList) async {
    await _prefs.setString(
        'alinan_siparis_bilgileri_listesi', jsonEncode(tList));
  }

  void getList() async {
    final List<dynamic> jsonData = jsonDecode(
        _prefs.getString('alinan_siparis_bilgileri_listesi') ?? '[]');
    alinanSiparisBilgileriList =
        jsonData.map<AlinanSiparisBilgileri>((jsonItem) {
      return AlinanSiparisBilgileri.fromJson(jsonItem);
    }).toList();
  }
}
