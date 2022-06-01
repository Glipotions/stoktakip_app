import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stoktakip_app/functions/const_entities.dart';
import 'package:stoktakip_app/model/gelen_urun_siparis/gelen_siparis.dart';
import 'package:stoktakip_app/model/gelen_urun_siparis/gelen_siparis_bilgileri.dart';
import 'package:stoktakip_app/model/verilen_siparis/verilen_siparis.dart';

class GelenSiparisBilgileriData with ChangeNotifier {
  static SharedPreferences _prefs = SharedPreferences as SharedPreferences;

  Future<void> createPrefObject() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveListToSharedPref(List<GelenSiparisBilgileri> tList) async {
    await _prefs.setString(
        'gelen_siparis_bilgileri_listesi', jsonEncode(tList));
    await _prefs.setBool('gelen_siparis_bilgisi_durum', gelenSiparisDurum!);
    if (gelenSiparisSingle.isSeciliSiparis != null) {
      await _prefs.setBool(
          'gelen_siparis_isSeciliSiparis', gelenSiparisSingle.isSeciliSiparis!);
    }

    await _prefs.setInt('verilen_siparis_single_id', verilenSiparisSingle.id!);
    await _prefs.setInt(
        'verilen_siparis_single_cari_id', verilenSiparisSingle.cariHesapId!);
    await _prefs.setString('verilen_siparis_single_siparisTanimi',
        verilenSiparisSingle.siparisTanimi!);
  }

  void getList() async {
    final List<dynamic> jsonData =
        jsonDecode(_prefs.getString('gelen_siparis_bilgileri_listesi') ?? '[]');
    gelenSiparisDurum = _prefs.getBool('gelen_siparis_bilgisi_durum');
    verilenSiparisSingle = VerilenSiparis(
        id: _prefs.getInt('verilen_siparis_single_id'),
        cariHesapId: _prefs.getInt('verilen_siparis_single_cari_id'),
        siparisTanimi: _prefs.getString('verilen_siparis_single_siparisTanimi'),
        aciklama: _prefs.getString('verilen_siparis_single_aciklama'));

    gelenSiparisSingle = GelenSiparis(
      aciklama: _prefs.getString('verilen_siparis_single_aciklama'),
      verilenSiparisId: _prefs.getInt('verilen_siparis_single_id'),
      siparisAdi: _prefs.getString('verilen_siparis_single_siparisTanimi'),
      durum: true,
      isSeciliSiparis: _prefs.getBool('gelen_siparis_isSeciliSiparis'),
    );

    gelenSiparisDurum == true
        ? gelenSiparisBilgileriList =
            jsonData.map<GelenSiparisBilgileri>((jsonItem) {
            return GelenSiparisBilgileri.fromJson(jsonItem);
          }).toList()
        : gelenSiparisBilgileriGetIdList =
            jsonData.map<GelenSiparisBilgileri>((jsonItem) {
            return GelenSiparisBilgileri.fromJson(jsonItem);
          }).toList();
  }
}
