import 'package:http/http.dart' as http;
import 'package:stoktakip_app/const/api_const.dart';

class KasaApiService {
  static Future fetchKasa() async {
    return await http.get(kasaGetUrl);
  }

  static Future fetchKasaById(int id) async {
    Uri idUrl = Uri.parse(kasaGetByIdUrl(id));
    return await http.get(idUrl);
  }
}
