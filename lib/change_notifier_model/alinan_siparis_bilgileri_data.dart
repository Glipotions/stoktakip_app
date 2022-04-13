import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stoktakip_app/functions/const_entities.dart';
import 'package:stoktakip_app/model/alinan_siparis/alinan_siparis_bilgileri.dart';

class AlinanSiparisBilgileriData with ChangeNotifier {
  static SharedPreferences _prefs = SharedPreferences as SharedPreferences;

  Future<void> createPrefObject() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveListToSharedPref(List<AlinanSiparisBilgileri> tList) async {
    String encodedData = '[';
    for (var item in tList) {
      if (encodedData != '[') {
        encodedData = encodedData + ',' + jsonEncode(item.toJsonWithId());
      } else {
        encodedData = encodedData + jsonEncode(item.toJsonWithId());
      }
    }
    encodedData = encodedData + ']';
    await _prefs.setString('alinan_siparis_bilgileri_listesi', encodedData);
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
