import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stoktakip_app/const/api_const.dart';
import 'package:stoktakip_app/model/cari_hesap/cari_hesap.dart';

class CariHesapApiService {
  static Future postCariHesap(CariHesap entity) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    var url = Uri.parse(cariHesapAddUrl);
    var myCariHesap = entity.toJson();
    var cariHesapBody = json.encode(myCariHesap);
    var res = await http.post(url, headers: header, body: cariHesapBody);
    print(res.statusCode);
    return res.statusCode;
  }

  static Future updateCariBakiyeById(int id, double tutar, String durum) async {
    var url =
        Uri.parse('$updateCariHesapBakiyeById$id&tutar=$tutar&durum=$durum');
    // return await http.put(url, headers: header);
    var res = await http.patch(url);
    print("Cari Bakiye result kod: ${res.statusCode}");
    return res.statusCode;
  }

  static Future postCariHesapHareketleri(
      int cariHesapId, int hareketId, String durum) async {
    var url =
        Uri.parse(cariHesapHareketleriAddUrl(cariHesapId, hareketId, durum));
    var res = await http.post(url);
    print("Cari Hareketleri: ${res.statusCode}");
    return res.statusCode;
  }

  static Future fetchCariHesap() async {
    return await http.get(cariHesapGetUri);
  }

  static Future fetchCariHesapById(int id) async {
    Uri idUrl = Uri.parse('$cariHesapGetByIdUrl$id');
    return await http.get(idUrl);
  }
}
