import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stoktakip_app/const/api_const.dart';
import 'package:stoktakip_app/model/nakit/nakit.dart';

class NakitApiService {
  static Future postNakit(Nakit entity) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    var url = Uri.parse(nakitAddUrl);
    var myEntity = entity.toJson();
    var entityBody = json.encode(myEntity);
    var res = await http.post(url, headers: header, body: entityBody);
    print("Nakit Ekle: ${res.statusCode}");
    return res.statusCode;
  }
}
