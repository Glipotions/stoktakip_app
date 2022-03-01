import 'dart:convert';

CariHesapHareketleri nakitFromJson(String str) =>
    CariHesapHareketleri.fromJson(json.decode(str));

String nakitToJson(CariHesapHareketleri data) => json.encode(data.toJson());

class CariHesapHareketleri {
  CariHesapHareketleri({
    required this.cariHesapId,
    this.satisFaturaId,
    this.nakitId,
    this.cekId,
    this.bankaHesapId,
    this.cekCikisiId,
    required this.id,
  });

  int cariHesapId;
  int? satisFaturaId;
  int? nakitId;
  int? cekId;
  int? bankaHesapId;
  int? cekCikisiId;
  int id;

  factory CariHesapHareketleri.fromJson(Map<String, dynamic> json) =>
      CariHesapHareketleri(
        cariHesapId: json["cariHesapId"],
        satisFaturaId: json["satisFaturaId"],
        nakitId: json["nakitId"],
        cekId: json["cekId"],
        bankaHesapId: json["bankaHesapId"],
        cekCikisiId: json["cekCikisiId"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "cariHesapId": cariHesapId,
        "satisFaturaId": satisFaturaId,
        "nakitId": nakitId,
        "cekId": cekId,
        "bankaHesapId": bankaHesapId,
        "cekCikisiId": cekCikisiId,
        "id": id,
      };
}
