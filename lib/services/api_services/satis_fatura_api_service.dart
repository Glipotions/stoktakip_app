import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:stoktakip_app/const/api_const.dart';
import 'package:stoktakip_app/model/satis_fatura/satis_fatura.dart';

class SatisFaturaApiService {
  static Future fetchSatisFatura() async {
    return await http.get(satisFaturaGetUrl);
  }

  static Future postSatisFatura(SatisFatura entity) async {
    Map<String, String> header = {
      'Content-type': 'application/json-patch+json',
      'Accept': '*/*'
    };
    var url = Uri.parse(satisFaturaAddUrl);
    var myEntity = entity.toJson();
    var postBody = json.encode(myEntity);
    var res = await http.post(url, headers: header, body: postBody);
    debugPrint("Satış Fatura result kod: ${res.statusCode}");
    return res.statusCode;
  }

  static Future updateSatisFatura(SatisFatura entity) async {
    Map<String, String> header = {
      'Content-type': 'application/json-patch+json',
      'Accept': '*/*'
    };
    var url = Uri.parse(satisFaturaUpdateUrl);
    var myEntity = entity.toJson();
    var updateBody = json.encode(myEntity);
    var res = await http.patch(url, headers: header, body: updateBody);
    debugPrint("Satış Fatura Update: ${res.statusCode}");
    return res.statusCode;
  }
}
