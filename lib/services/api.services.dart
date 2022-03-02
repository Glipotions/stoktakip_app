// // ignore_for_file: avoid_print

// import 'dart:convert';

// import 'package:stoktakip_app/const/api_const.dart';
// import 'package:stoktakip_app/model/cari_hesap/cari_hesap.dart';
// import 'package:stoktakip_app/model/nakit/nakit.dart';
// import 'package:stoktakip_app/model/satin_alma/satin_alma_fatura.dart';
// import 'package:stoktakip_app/model/satis_fatura/satis_fatura.dart';
// import 'package:http/http.dart' as http;
// import 'package:stoktakip_app/model/urun/urun.dart';
// import 'package:stoktakip_app/model/satis_fatura/urun_bilgileri.dart';
// import 'package:stoktakip_app/model/satin_alma/urun_bilgileri_satin_alma.dart';

// class APIServices {
//   List<UrunBilgileri> fetchUrunBilgileri(String responseBody) {
//     var l = json.decode(responseBody) as List<dynamic>;
//     var urunbilgileris =
//         l.map((model) => UrunBilgileri.fromJson(model)).toList();
//     return urunbilgileris;
//   }

//   static Future fetchUrunBilgileriBySatisFaturaId(id) async {
//     // Uri idUrl = Uri.parse('$urunBilgileriGetBySatisFaturaIdUrl$id');
//     Uri idUrl = Uri.parse(urunBilgileriGetBySatisFaturaIdUrl(id));
//     return await http.get(idUrl);
//   }

//   static Future postUrunBilgileri(UrunBilgileri entity) async {
//     Map<String, String> header = {
//       'Content-type': 'application/json',
//       'Accept': 'application/json'
//     };
//     var url = Uri.parse(urunBilgileriAddUrl);
//     var myEntity = entity.toJson();
//     var postBody = json.encode(myEntity);
//     var res = await http.post(url, headers: header, body: postBody);
//     print("Ürün Bilgisi Ekle: ${res.statusCode}");
//     return res.statusCode;
//   }

//   static Future deleteUrunBilgileri(UrunBilgileri entity) async {
//     Map<String, String> header = {
//       'Content-type': 'application/json-patch+json',
//       'Accept': 'application/json'
//     };
//     // for (var entity in entities) {
//     var url = Uri.parse(urunBilgileriDeleteUrl);
//     var myEntity = entity.toJsonWithId();
//     var deleteBody = json.encode(myEntity);
//     var res = await http.delete(url, headers: header, body: deleteBody);
//     print("Ürün Bilgisi Silindi: ${res.statusCode}");

//     // }
//     return res.statusCode;
//   }

//   static Future postUrunBilgileriSatinAlma(
//       UrunBilgileriSatinAlma entity) async {
//     Map<String, String> header = {
//       'Content-type': 'application/json',
//       'Accept': 'application/json'
//     };
//     var url = Uri.parse(urunBilgileriSatinAlmaAddUrl);
//     var myEntity = entity.toJson();
//     var postBody = json.encode(myEntity);
//     var res = await http.post(url, headers: header, body: postBody);
//     print(res.statusCode);
//     return res.statusCode;
//   }

//   static Future fetchSatisFatura() async {
//     return await http.get(satisFaturaGetUrl);
//   }

//   static Future postSatisFatura(SatisFatura entity) async {
//     Map<String, String> header = {
//       'Content-type': 'application/json-patch+json',
//       'Accept': '*/*'
//     };
//     var url = Uri.parse(satisFaturaAddUrl);
//     var myEntity = entity.toJson();
//     var postBody = json.encode(myEntity);
//     var res = await http.post(url, headers: header, body: postBody);
//     print("Satış Fatura result kod: ${res.statusCode}");
//     return res.statusCode;
//   }

//   static Future updateSatisFatura(SatisFatura entity) async {
//     Map<String, String> header = {
//       'Content-type': 'application/json-patch+json',
//       'Accept': '*/*'
//     };
//     var url = Uri.parse(satisFaturaUpdateUrl);
//     var myEntity = entity.toJson();
//     var updateBody = json.encode(myEntity);
//     var res = await http.patch(url, headers: header, body: updateBody);
//     print("Satış Fatura Update: ${res.statusCode}");
//     return res.statusCode;
//   }

//   static Future postSatinAlmaFatura(SatinAlmaFatura entity) async {
//     Map<String, String> header = {
//       'Content-type': 'application/json-patch+json',
//       'Accept': '*/*'
//     };
//     var url = Uri.parse(satinAlmaFaturaAddUrl);
//     var myEntity = entity.toJson();
//     var postBody = json.encode(myEntity);
//     var res = await http.post(url, headers: header, body: postBody);
//     print(res.statusCode);
//     return res.statusCode;
//   }

//   static Future fetchCariHesap() async {
//     return await http.get(cariHesapGetUri);
//   }

//   static Future fetchCariHesapById(int id) async {
//     Uri idUrl = Uri.parse('$cariHesapGetByIdUrl$id');
//     return await http.get(idUrl);
//   }

//   static Future postCariHesap(CariHesap entity) async {
//     Map<String, String> header = {
//       'Content-type': 'application/json',
//       'Accept': 'application/json'
//     };
//     var url = Uri.parse(cariHesapAddUrl);
//     var myCariHesap = entity.toJson();
//     var cariHesapBody = json.encode(myCariHesap);
//     var res = await http.post(url, headers: header, body: cariHesapBody);
//     print(res.statusCode);
//     return res.statusCode;
//   }

//   static Future postNakit(Nakit entity) async {
//     Map<String, String> header = {
//       'Content-type': 'application/json',
//       'Accept': 'application/json'
//     };
//     var url = Uri.parse(nakitAddUrl);
//     var myEntity = entity.toJson();
//     var entityBody = json.encode(myEntity);
//     var res = await http.post(url, headers: header, body: entityBody);
//     print("Nakit Ekle: ${res.statusCode}");
//     return res.statusCode;
//   }

//   static Future postCariHesapHareketleri(
//       int cariHesapId, int hareketId, String durum) async {
//     var url =
//         Uri.parse(cariHesapHareketleriAddUrl(cariHesapId, hareketId, durum));
//     var res = await http.post(url);
//     print("Cari Hareketleri: ${res.statusCode}");
//     return res.statusCode;
//   }

//   static Future postKasaHareketleri(
//       int kasaId, int hareketId, String durum) async {
//     var url = Uri.parse(kasaHareketleriAddUrl(kasaId, hareketId, durum));
//     var res = await http.post(url);
//     print("Kasa Hareketleri: ${res.statusCode}");
//     return res.statusCode;
//   }

//   static Future updateKasa(int id, double bakiye) async {
//     // String urlString = kasaUpdateBakiyeUrl(id, bakiye);
//     var url = Uri.parse(kasaUpdateBakiyeUrl(id, bakiye));
//     var res = await http.patch(url);
//     print("Kasa Bakiye Update: ${res.statusCode}");
//     return res.statusCode;
//   }

//   static Future fetchKasa() async {
//     return await http.get(kasaGetUrl);
//   }

//   static Future fetchKasaById(int id) async {
//     Uri idUrl = Uri.parse(kasaGetByIdUrl(id));
//     return await http.get(idUrl);
//   }

//   static Future fetchUrunIdByBarcode(String barkod) async {
//     Uri urunUrl = Uri.parse('$urunBarkodBilgileriGetUrunUrl$barkod');
//     return await http.get(urunUrl);
//   }

//   static Future fetchUrunById(int? id) async {
//     Uri urunUrl = Uri.parse('$urunGetByIdUrl$id');
//     return await http.get(urunUrl);
//   }

//   static Future fetchUrunByCode(String? code) async {
//     Uri urunUrl = Uri.parse('$urunGetByCodeUrl$code');
//     return await http.get(urunUrl);
//   }

//   static Future getUrunById(UrunBilgileri cart) async {
//     var urun = <Urun>[];
//     String urunAdi = 'x';
//     fetchUrunById(cart.urunId).then((response) {
//       dynamic list = json.decode(response.body!);
//       List data = list['data'];
//       urun = data.map((model) => Urun.fromJson(model)).toList();
//       for (var element in urun) {
//         urunAdi = element.urunAdi;
//       }
//     });
//     return urunAdi;
//   }

//   static Future updateUrunStokById(int id, int stok, bool durum) async {
//     var url = Uri.parse('$updateUrunById$id&stok=$stok&durum=$durum');
//     var res = await http.patch(url);
//     print("ürün stok update result kod: ${res.statusCode}");
//     return res.statusCode;
//   }

//   static Future updateCariBakiyeById(int id, double tutar, String durum) async {
//     // Map<String, String> header = {
//     //   'Content-type': 'application/json',
//     //   'Accept': 'application/json'
//     //;
//     var url =
//         Uri.parse('$updateCariHesapBakiyeById$id&tutar=$tutar&durum=$durum');
//     // return await http.put(url, headers: header);
//     var res = await http.patch(url);
//     print("Cari Bakiye result kod: ${res.statusCode}");
//     return res.statusCode;
//   }
// }
