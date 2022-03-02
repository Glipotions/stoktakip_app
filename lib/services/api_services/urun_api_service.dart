import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stoktakip_app/const/api_const.dart';
import 'package:stoktakip_app/model/satis_fatura/urun_bilgileri.dart';
import 'package:stoktakip_app/model/urun/urun.dart';

class UrunApiService {
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

  static Future updateUrunStokById(int id, int stok, bool durum) async {
    var url = Uri.parse('$updateUrunById$id&stok=$stok&durum=$durum');
    var res = await http.patch(url);
    print("ürün stok update result kod: ${res.statusCode}");
    return res.statusCode;
  }
}
