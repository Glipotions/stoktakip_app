import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stoktakip_app/functions/const_entities.dart';
import 'package:stoktakip_app/model/verilen_siparis/verilen_siparis_bilgileri.dart';

class VerilenSiparisBilgileriData with ChangeNotifier {
  static SharedPreferences _prefs = SharedPreferences as SharedPreferences;

  Future<void> createPrefObject() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveListToSharedPref(List<VerilenSiparisBilgileri> tList) async {
    String encodedData = '[';
    for (var item in tList) {
      if (encodedData != '[') {
        encodedData = encodedData + ',' + jsonEncode(item.toJsonWithId());
      } else {
        encodedData = encodedData + jsonEncode(item.toJsonWithId());
      }
    }
    encodedData = encodedData + ']';
    await _prefs.setString('verilen_siparis_bilgileri_listesi', encodedData);
  }

  void getList() async {
    final List<dynamic> jsonData = jsonDecode(
        _prefs.getString('verilen_siparis_bilgileri_listesi') ?? '[]');
    verilenSiparisBilgileriList =
        jsonData.map<VerilenSiparisBilgileri>((jsonItem) {
      return VerilenSiparisBilgileri.fromJson(jsonItem);
    }).toList();
  }
}
