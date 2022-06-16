import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:stoktakip_app/const/api_const.dart';
import 'package:stoktakip_app/model/hazirlanan_siparis/hazirlanan_siparis.dart';
import 'package:stoktakip_app/model/hazirlanan_siparis/hazirlanan_siparis_bilgileri.dart';

class HazirlananSiparisApiService {
  static Future fetchHazirlananSiparis() async {
    return await http.get(fetchHazirlananSiparisUrl);
  }

  static Future postHazirlananSiparis(HazirlananSiparis entity) async {
    Map<String, String> header = {
      'Content-type': 'application/json-patch+json',
      'Accept': '*/*'
    };
    var url = Uri.parse(hazirlananSiparisAddUrl);
    var myEntity = entity.toJson();
    var postBody = json.encode(myEntity);
    var res = await http.post(url, headers: header, body: postBody);
    debugPrint("HazirlananSiparis result kod: ${res.statusCode}");
    return res.statusCode;
  }

// HAZIRLANAN SİPARİŞ BİLGİLERİ

  static Future postHazirlananSiparisBilgileri(
      HazirlananSiparisBilgileri entity) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    var url = Uri.parse(hazirlananSiparisBilgileriAddUrl);
    var myEntity = entity.toJson();
    var postBody = json.encode(myEntity);
    var res = await http.post(url, headers: header, body: postBody);
    debugPrint("HazirlananSiparisBilgileri Ekle: ${res.statusCode}");
    return res.statusCode;
  }

  static Future fetchHazirlananSiparisBilgileriByHazirlananSiparisId(id) async {
    // Uri idUrl = Uri.parse('$urunBilgileriGetBySatisFaturaIdUrl$id');
    Uri idUrl =
        Uri.parse(hazirlananSiparisBilgileriGetByHazirlananSiparisIdUrl(id));
    return await http.get(idUrl);
  }

  static Future deleteHazirlananSiparisBilgileri(
      HazirlananSiparisBilgileri entity) async {
    Map<String, String> header = {
      'Content-type': 'application/json-patch+json',
      'Accept': 'application/json'
    };
    // for (var entity in entities) {
    var url = Uri.parse(hazirlananSiparisBilgileriDeleteUrl);
    var myEntity = entity.toJsonWithId();
    var deleteBody = json.encode(myEntity);
    var res = await http.delete(url, headers: header, body: deleteBody);
    debugPrint("Ürün Bilgisi Silindi: ${res.statusCode}");

    // }
    return res.statusCode;
  }

  static Future updateHazirlananSiparisBilgileri(
      HazirlananSiparisBilgileri entity) async {
    Map<String, String> header = {
      'Content-type': 'application/json-patch+json',
      'Accept': 'application/json'
    };
    // for (var entity in entities) {
    var url = Uri.parse(hazirlananSiparisBilgileriUpdateUrl);
    var myEntity = entity.toJsonWithId();
    var updateBody = json.encode(myEntity);
    var res = await http.patch(url, headers: header, body: updateBody);
    debugPrint("Hazırlanan Sipariş Bilgisi Güncellendi: ${res.statusCode}");

    return res.statusCode;
  }
}
