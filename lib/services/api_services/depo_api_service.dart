import 'package:http/http.dart' as http;
import 'package:stoktakip_app/const/api_const.dart';

class DepoApiService {
  static Future fetchDepo() async {
    return await http.get(depoGetUrl);
  }

  static Future fetchDepoById(int id) async {
    Uri idUrl = Uri.parse(depoGetByIdUrl(id));
    return await http.get(idUrl);
  }
}
