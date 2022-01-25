// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:stoktakip_app/const/api_const.dart';
import 'package:stoktakip_app/model/cari_hesap.dart';
import 'package:stoktakip_app/model/satis_fatura.dart';
import 'package:http/http.dart' as http;
import 'package:stoktakip_app/model/urun.dart';
import 'package:stoktakip_app/model/urun_bilgileri.dart';

class APIServices {
  List<UrunBilgileri> fetchUrunBilgileri(String responseBody) {
    var l = json.decode(responseBody) as List<dynamic>;
    var urunbilgileris =
        l.map((model) => UrunBilgileri.fromJson(model)).toList();
    return urunbilgileris;
  }

  static Future postUrunBilgileri(UrunBilgileri urunBilgileri) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    var url = Uri.parse(urunBilgileriAddUrl);
    var myEntity = urunBilgileri.toJson();
    var postBody = json.encode(myEntity);
    var res = await http.post(url, headers: header, body: postBody);
    print(res.statusCode);
    return res.statusCode;
  }

  // List<CariHesap> fetchCariHesap(String responseBody) {
  //   var l = json.decode(responseBody) as List<dynamic>;
  //   var carihesaps = l.map((model) => CariHesap.fromJson(model)).toList();
  //   return carihesaps;
  // }
  static Future fetchSatisFatura() async {
    return await http.get(satisFaturaGetUrl);
  }

  static Future postSatisFatura(SatisFatura satisFatura) async {
    Map<String, String> header = {
      'Content-type': 'application/json-patch+json',
      'Accept': '*/*'
    };
    var url = Uri.parse(satisFaturaAddUrl);
    var myEntity = satisFatura.toJson();
    var postBody = json.encode(myEntity);
    var res = await http.post(url, headers: header, body: postBody);
    print(res.statusCode);
    return res.statusCode;
  }

  static Future fetchCariHesap() async {
    return await http.get(cariHesapGetUri);
  }

  static Future fetchCariHesapById(int id) async {
    Uri idUrl = Uri.parse('$cariHesapGetByIdUrl$id');
    return await http.get(idUrl);
  }

  static Future postCariHesap(CariHesap cariHesap) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    var url = Uri.parse(cariHesapAddUrl);
    var myCariHesap = cariHesap.toJson();
    var cariHesapBody = json.encode(myCariHesap);
    var res = await http.post(url, headers: header, body: cariHesapBody);
    print(res.statusCode);
    return res.statusCode;
  }

  static Future fetchUrunIdByBarcode(String barkod) async {
    Uri urunUrl = Uri.parse('$urunBarkodBilgileriGetUrunUrl$barkod');
    return await http.get(urunUrl);
  }

  static Future fetchUrunById(int? id) async {
    Uri urunUrl = Uri.parse('$urunGetByIdUrl$id');
    return await http.get(urunUrl);
  }

  static Future fetchUrunByCode(String? code) async {
    Uri urunUrl = Uri.parse('$urunGetByCodeUrl$code');
    return await http.get(urunUrl);
  }

  static Future getUrunById(UrunBilgileri cart) async {
    var urun = <Urun>[];
    String urunAdi = 'x';
    fetchUrunById(cart.urunId).then((response) {
      dynamic list = json.decode(response.body!);
      List data = list['data'];
      urun = data.map((model) => Urun.fromJson(model)).toList();
      for (var element in urun) {
        urunAdi = element.urunAdi;
      }
    });
    return urunAdi;
  }

  static Future updateUrunStokById(int id, int stok) async {
    var url = Uri.parse('${updateUrunById}${id}&stok=${stok}');
    var res = await http.patch(url);
    print("ürün stok update result kod: ${res.statusCode}");
    return res.statusCode;
  }

  static Future updateCariBakiyeById(int id, double bakiye) async {
    // Map<String, String> header = {
    //   'Content-type': 'application/json-patch+json',
    //   'Accept': '*/*'
    // };
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    var url = Uri.parse('${updateCariHesapBakiyeById}${id}&bakiye=${bakiye}');
    // return await http.put(url, headers: header);
    var res = await http.patch(url);
    print("Cari Bakiye result kod: ${res.statusCode}");
    return res.statusCode;
  }
}
