import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stoktakip_app/functions/const_entities.dart';
import 'package:stoktakip_app/model/alinan_siparis/alinan_siparis.dart';
import 'package:stoktakip_app/model/hazirlanan_siparis/hazirlanan_siparis.dart';
import 'package:stoktakip_app/model/hazirlanan_siparis/hazirlanan_siparis_bilgileri.dart';

class HazirlananSiparisBilgileriData with ChangeNotifier {
  static SharedPreferences _prefs = SharedPreferences as SharedPreferences;

  Future<void> createPrefObject() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveListToSharedPref(
      List<HazirlananSiparisBilgileri> tList) async {
    await _prefs.setString(
        'hazirlanan_siparis_bilgileri_listesi', jsonEncode(tList));
    await _prefs.setBool(
        'hazirlanan_siparis_bilgisi_durum', hazirlananSiparisDurum!);
    if (hazirlananSiparisSingle.isSeciliSiparis != null) {
      await _prefs.setBool('hazirlanan_siparis_isSeciliSiparis',
          hazirlananSiparisSingle.isSeciliSiparis!);
    }

    await _prefs.setInt('alinan_siparis_single_id', alinanSiparisSingle.id!);
    await _prefs.setInt(
        'alinan_siparis_single_cari_id', alinanSiparisSingle.cariHesapId!);
    await _prefs.setString('alinan_siparis_single_siparisTanimi',
        alinanSiparisSingle.siparisTanimi!);
  }

  void getList() async {
    final List<dynamic> jsonData = jsonDecode(
        _prefs.getString('hazirlanan_siparis_bilgileri_listesi') ?? '[]');
    hazirlananSiparisDurum = _prefs.getBool('hazirlanan_siparis_bilgisi_durum');
    alinanSiparisSingle = AlinanSiparis(
        id: _prefs.getInt('alinan_siparis_single_id'),
        cariHesapId: _prefs.getInt('alinan_siparis_single_cari_id'),
        siparisTanimi: _prefs.getString('alinan_siparis_single_siparisTanimi'),
        aciklama: _prefs.getString('alinan_siparis_single_aciklama'));

    hazirlananSiparisSingle = HazirlananSiparis(
      aciklama: _prefs.getString('alinan_siparis_single_aciklama'),
      alinanSiparisId: _prefs.getInt('alinan_siparis_single_id'),
      siparisAdi: _prefs.getString('alinan_siparis_single_siparisTanimi'),
      durum: true,
      isSeciliSiparis: _prefs.getBool('hazirlanan_siparis_isSeciliSiparis'),
    );

    hazirlananSiparisDurum == true
        ? hazirlananSiparisBilgileriList =
            jsonData.map<HazirlananSiparisBilgileri>((jsonItem) {
            return HazirlananSiparisBilgileri.fromJson(jsonItem);
          }).toList()
        : hazirlananSiparisBilgileriGetIdList =
            jsonData.map<HazirlananSiparisBilgileri>((jsonItem) {
            return HazirlananSiparisBilgileri.fromJson(jsonItem);
          }).toList();
  }
}
