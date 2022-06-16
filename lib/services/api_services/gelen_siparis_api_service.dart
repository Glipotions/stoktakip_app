import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:stoktakip_app/const/api_const.dart';
import 'package:stoktakip_app/model/gelen_urun_siparis/gelen_siparis.dart';
import 'package:stoktakip_app/model/gelen_urun_siparis/gelen_siparis_bilgileri.dart';

class GelenSiparisApiService {
  static Future fetchGelenSiparis() async {
    return await http.get(fetchGelenSiparisUrl);
  }

  static Future postGelenSiparis(GelenSiparis entity) async {
    Map<String, String> header = {
      'Content-type': 'application/json-patch+json',
      'Accept': '*/*'
    };
    var url = Uri.parse(gelenSiparisAddUrl);
    var myEntity = entity.toJson();
    var postBody = json.encode(myEntity);
    var res = await http.post(url, headers: header, body: postBody);
    debugPrint("GelenSiparis result kod: ${res.statusCode}");
    return res.statusCode;
  }

// HAZIRLANAN SİPARİŞ BİLGİLERİ

  static Future postGelenSiparisBilgileri(GelenSiparisBilgileri entity) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    var url = Uri.parse(gelenSiparisBilgileriAddUrl);
    var myEntity = entity.toJson();
    var postBody = json.encode(myEntity);
    var res = await http.post(url, headers: header, body: postBody);
    debugPrint("GelenSiparisBilgileri Ekle: ${res.statusCode}");
    return res.statusCode;
  }

  static Future fetchGelenSiparisBilgileriByGelenSiparisId(id) async {
    // Uri idUrl = Uri.parse('$urunBilgileriGetBySatisFaturaIdUrl$id');
    Uri idUrl = Uri.parse(gelenSiparisBilgileriGetByGelenSiparisIdUrl(id));
    return await http.get(idUrl);
  }

  static Future deleteGelenSiparisBilgileri(
      GelenSiparisBilgileri entity) async {
    Map<String, String> header = {
      'Content-type': 'application/json-patch+json',
      'Accept': 'application/json'
    };
    // for (var entity in entities) {
    var url = Uri.parse(gelenSiparisBilgileriDeleteUrl);
    var myEntity = entity.toJsonWithId();
    var deleteBody = json.encode(myEntity);
    var res = await http.delete(url, headers: header, body: deleteBody);
    debugPrint("Ürün Bilgisi Silindi: ${res.statusCode}");

    // }
    return res.statusCode;
  }

  static Future updateGelenSiparisBilgileri(
      GelenSiparisBilgileri entity) async {
    Map<String, String> header = {
      'Content-type': 'application/json-patch+json',
      'Accept': 'application/json'
    };
    // for (var entity in entities) {
    var url = Uri.parse(gelenSiparisBilgileriUpdateUrl);
    var myEntity = entity.toJsonWithId();
    var updateBody = json.encode(myEntity);
    var res = await http.patch(url, headers: header, body: updateBody);
    debugPrint("Hazırlanan Sipariş Bilgisi Güncellendi: ${res.statusCode}");

    return res.statusCode;
  }
}
