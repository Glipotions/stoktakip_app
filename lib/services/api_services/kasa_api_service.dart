import 'package:http/http.dart' as http;
import 'package:stoktakip_app/const/api_const.dart';

class KasaApiService {
  // static Future updateKasa(int id, double bakiye) async {
  //   // String urlString = kasaUpdateBakiyeUrl(id, bakiye);
  //   var url = Uri.parse(kasaUpdateBakiyeUrl(id, bakiye));
  //   var res = await http.patch(url);
  //   print("Kasa Bakiye Update: ${res.statusCode}");
  //   return res.statusCode;
  // }

  static Future fetchKasa() async {
    return await http.get(kasaGetUrl);
  }

  static Future fetchKasaById(int id) async {
    Uri idUrl = Uri.parse(kasaGetByIdUrl(id));
    return await http.get(idUrl);
  }

  // static Future postKasaHareketleri(
  //     int kasaId, int hareketId, String durum) async {
  //   var url = Uri.parse(kasaHareketleriAddUrl(kasaId, hareketId, durum));
  //   var res = await http.post(url);
  //   print("Kasa Hareketleri: ${res.statusCode}");
  //   return res.statusCode;
  // }
}
