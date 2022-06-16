import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:stoktakip_app/const/api_const.dart';
import 'package:stoktakip_app/model/satin_alma/urun_bilgileri_satin_alma.dart';

class UrunBilgileriSatinAlmaApiService {
  static Future postUrunBilgileriSatinAlma(
      UrunBilgileriSatinAlma entity) async {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    var url = Uri.parse(urunBilgileriSatinAlmaAddUrl);
    var myEntity = entity.toJson();
    var postBody = json.encode(myEntity);
    var res = await http.post(url, headers: header, body: postBody);
    debugPrint("${res.statusCode}");
    return res.statusCode;
  }
}
