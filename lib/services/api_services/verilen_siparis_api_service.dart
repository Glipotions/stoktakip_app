import 'dart:convert';

import 'package:stoktakip_app/const/api_const.dart';
import 'package:http/http.dart' as http;
import 'package:stoktakip_app/model/verilen_siparis/verilen_siparis_bilgileri.dart';

class VerilenSiparisApiService {
  static Future fetchVerilenSiparis() async {
    return await http.get(fetchVerilenSiparisUrl);
  }

  static Future updateVerilenSiparisDurumById(int id) async {
    var url = Uri.parse('$updateVerilenSiparisDurumByIdUrl$id');
    var res = await http.patch(url);
    print("Alınan Sipariş result kod: ${res.statusCode}");
    return res.statusCode;
  }

  static Future fetchVerilenSiparisBilgileriById(int id) async {
    Uri idUrl =
        Uri.parse('$fetchVerilenSiparisBilgileriByVerilenSiparisIdUrl$id');
    return await http.get(idUrl);
  }

  static Future fetchVerilenSiparisBilgileriByCariId(int id) async {
    Uri idUrl = Uri.parse('$fetchVerilenSiparisBilgileriByCariIdUrl$id');
    return await http.get(idUrl);
  }

  static Future fetchVerilenSiparisBilgileriByCariIdControl(int id) async {
    Uri idUrl = Uri.parse('$fetchVerilenSiparisBilgileriByCariIdControlUrl$id');
    return await http.get(idUrl);
  }

  static Future updateVerilenSiparisBilgileri(
      VerilenSiparisBilgileri entity) async {
    Map<String, String> header = {
      'Content-type': 'application/json-patch+json',
      'Accept': 'application/json'
    };
    // for (var entity in entities) {
    var url = Uri.parse(updateVerilenSiparisBilgileriUrl);
    var myEntity = entity.toJsonWithId();
    var updateBody = json.encode(myEntity);
    var res = await http.patch(url, headers: header, body: updateBody);
    print("Alınan Sipariş Bilgisi Güncellendi: ${res.statusCode}");

    return res.statusCode;
  }
}
