import 'package:stoktakip_app/const/api_const.dart';
import 'package:http/http.dart' as http;

class AlinanSiparisApiService {
  static Future fetchAlinanSiparis() async {
    return await http.get(fetchAlinanSiparisUrl);
  }
}
