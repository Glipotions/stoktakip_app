import 'dart:convert';

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
    print("HazirlananSiparis result kod: ${res.statusCode}");
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
    print("HazirlananSiparisBilgileri Ekle: ${res.statusCode}");
    return res.statusCode;
  }
}
