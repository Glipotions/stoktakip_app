import 'dart:convert';

Depo depoFromJson(String str) => Depo.fromJson(json.decode(str));

String depoToJson(Depo data) => json.encode(data.toJson());

class Depo {
  Depo({
    this.kod,
    this.depoAdi,
    this.ozelKod1Adi,
    this.ozelKod2Adi,
    this.id,
    this.durum,
  });

  String? kod;
  String? depoAdi;
  String? ozelKod1Adi;
  String? ozelKod2Adi;
  int? id;
  bool? durum;

  factory Depo.fromJson(Map<String, dynamic> json) => Depo(
        kod: json["kod"],
        depoAdi: json["depoAdi"],
        durum: json["durum"],
        ozelKod1Adi: json["ozelKod1Adi"],
        ozelKod2Adi: json["ozelKod2Adi"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "kod": kod,
        "depoAdi": depoAdi,
        "durum": durum,
        "ozelKod1Adi": ozelKod1Adi,
        "ozelKod2Adi": ozelKod2Adi,
        "id": id,
      };
}
