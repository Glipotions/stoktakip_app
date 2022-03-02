import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stoktakip_app/const/api_const.dart';
import 'package:stoktakip_app/model/satin_alma/satin_alma_fatura.dart';

class SatinAlmaFaturaApiService {
  static Future postSatinAlmaFatura(SatinAlmaFatura entity) async {
    Map<String, String> header = {
      'Content-type': 'application/json-patch+json',
      'Accept': '*/*'
    };
    var url = Uri.parse(satinAlmaFaturaAddUrl);
    var myEntity = entity.toJson();
    var postBody = json.encode(myEntity);
    var res = await http.post(url, headers: header, body: postBody);
    print(res.statusCode);
    return res.statusCode;
  }
}
