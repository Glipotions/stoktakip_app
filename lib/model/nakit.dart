import 'package:meta/meta.dart';
import 'dart:convert';

Nakit nakitFromJson(String str) => Nakit.fromJson(json.decode(str));

String nakitToJson(Nakit data) => json.encode(data.toJson());

class Nakit {
  Nakit({
    required this.cariHesapId,
    required this.kasaId,
    this.tarih,
    required this.cariHesapTuru,
    required this.dovizTuru,
    required this.tutar,
    required this.dovizliTutar,
    required this.id,
  });

  int cariHesapId;
  int kasaId;
  DateTime? tarih;
  int cariHesapTuru;
  int dovizTuru;
  double tutar;
  double dovizliTutar;
  int id;

  factory Nakit.fromJson(Map<String, dynamic> json) => Nakit(
        cariHesapId: json["cariHesapId"],
        kasaId: json["kasaId"],
        tarih: DateTime.parse(json["tarih"]),
        cariHesapTuru: json["cariHesapTuru"],
        dovizTuru: json["dovizTuru"],
        tutar: json["tutar"].toDouble(),
        dovizliTutar: json["dovizliTutar"].toDouble(),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "cariHesapId": cariHesapId,
        "kasaId": kasaId,
        "tarih": tarih!.toIso8601String(),
        "cariHesapTuru": cariHesapTuru,
        "dovizTuru": dovizTuru,
        "tutar": tutar,
        "dovizliTutar": dovizliTutar,
        "id": id,
      };
}
