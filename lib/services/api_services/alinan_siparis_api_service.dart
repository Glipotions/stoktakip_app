import 'dart:convert';

import 'package:stoktakip_app/const/api_const.dart';
import 'package:http/http.dart' as http;
import 'package:stoktakip_app/model/alinan_siparis/alinan_siparis_bilgileri.dart';

class AlinanSiparisApiService {
  static Future fetchAlinanSiparis() async {
    return await http.get(fetchAlinanSiparisUrl);
  }

  static Future updateAlinanSiparisDurumById(int id) async {
    var url = Uri.parse('$updateAlinanSiparisDurumByIdUrl$id');
    var res = await http.patch(url);
    print("Alınan Sipariş result kod: ${res.statusCode}");
    return res.statusCode;
  }

  static Future fetchAlinanSiparisBilgileriById(int id) async {
    Uri idUrl =
        Uri.parse('$fetchAlinanSiparisBilgileriByAlinanSiparisIdUrl$id');
    return await http.get(idUrl);
  }

  static Future fetchAlinanSiparisBilgileriByCariId(int id) async {
    Uri idUrl = Uri.parse('$fetchAlinanSiparisBilgileriByCariIdUrl$id');
    return await http.get(idUrl);
  }

  static Future fetchAlinanSiparisBilgileriByCariIdControl(int id) async {
    Uri idUrl = Uri.parse('$fetchAlinanSiparisBilgileriByCariIdControlUrl$id');
    return await http.get(idUrl);
  }

  static Future updateAlinanSiparisBilgileri(
      AlinanSiparisBilgileri entity) async {
    Map<String, String> header = {
      'Content-type': 'application/json-patch+json',
      'Accept': 'application/json'
    };
    // for (var entity in entities) {
    var url = Uri.parse(updateAlinanSiparisBilgileriUrl);
    var myEntity = entity.toJsonWithId();
    var updateBody = json.encode(myEntity);
    var res = await http.patch(url, headers: header, body: updateBody);
    print("Alınan Sipariş Bilgisi Güncellendi: ${res.statusCode}");

    return res.statusCode;
  }
}
