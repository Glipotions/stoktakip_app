import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stoktakip_app/const/api_const.dart';
import 'package:stoktakip_app/model/satis_fatura/urun_bilgileri.dart';

class UrunBilgileriApiService {
  List<UrunBilgileri> fetchUrunBilgileri(String responseBody) {
    var l = json.decode(responseBody) as List<dynamic>;
    var urunbilgileris =
        l.map((model) => UrunBilgileri.fromJson(model)).toList();
    return urunbilgileris;
  }

  static Future fetchUrunBilgileriBySatisFaturaId(id) async {
    // Uri idUrl = Uri.parse('$urunBilgileriGetBySatisFaturaIdUrl$id');
    Uri idUrl = Uri.parse(urunBilgileriGetBySatisFaturaIdUrl(id));
    return await http.get(idUrl);
  }

  static Future postUrunBilgileri(UrunBilgileri entity) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    var url = Uri.parse(urunBilgileriAddUrl);
    var myEntity = entity.toJson();
    var postBody = json.encode(myEntity);
    var res = await http.post(url, headers: header, body: postBody);
    print("Ürün Bilgisi Ekle: ${res.statusCode}");
    return res.statusCode;
  }

  static Future deleteUrunBilgileri(UrunBilgileri entity) async {
    Map<String, String> header = {
      'Content-type': 'application/json-patch+json',
      'Accept': 'application/json'
    };
    // for (var entity in entities) {
    var url = Uri.parse(urunBilgileriDeleteUrl);
    var myEntity = entity.toJsonWithId();
    var deleteBody = json.encode(myEntity);
    var res = await http.delete(url, headers: header, body: deleteBody);
    print("Ürün Bilgisi Silindi: ${res.statusCode}");

    // }
    return res.statusCode;
  }

  static Future updateUrunBilgileri(UrunBilgileri entity) async {
    Map<String, String> header = {
      'Content-type': 'application/json-patch+json',
      'Accept': 'application/json'
    };
    // for (var entity in entities) {
    var url = Uri.parse(urunBilgileriDeleteUrl);
    var myEntity = entity.toJsonWithId();
    var deleteBody = json.encode(myEntity);
    var res = await http.delete(url, headers: header, body: deleteBody);
    print("Ürün Bilgisi Silindi: ${res.statusCode}");

    // }
    return res.statusCode;
  }
}
