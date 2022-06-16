import 'dart:convert';

List<GelenSiparis> satisFaturaFromJson(String str) => List<GelenSiparis>.from(
    json.decode(str).map((x) => GelenSiparis.fromJson(x)));

String satisFaturaToJson(List<GelenSiparis> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GelenSiparis {
  int? id;
  String? kod;
  int? verilenSiparisId;
  DateTime? tarih;
  String? siparisAdi;
  int? ozelKod1Id;
  String? ozelKod1Adi;
  String? aciklama;
  bool? durum = true;
  bool? isSeciliSiparis = true;
  int? cariHesapId;
  int? depoId;

  GelenSiparis({
    this.kod,
    this.tarih,
    this.id,
    this.verilenSiparisId,
    this.siparisAdi,
    this.ozelKod1Id,
    this.ozelKod1Adi,
    this.aciklama,
    this.durum,
    this.isSeciliSiparis,
    this.cariHesapId,
    this.depoId,
  });

  factory GelenSiparis.fromJson(Map<String, dynamic> json) => GelenSiparis(
        kod: json["kod"],
        tarih: DateTime.parse(json["tarih"]),
        id: json["id"],
        verilenSiparisId: json["verilenSiparisId"],
        ozelKod1Id: json["ozelKod1Id"],
        ozelKod1Adi: json["ozelKod1Adi"],
        siparisAdi: json["siparisAdi"],
        aciklama: json["aciklama"],
        durum: json["durum"],
        isSeciliSiparis: json["isSeciliSiparis"],
        cariHesapId: json["cariHesapId"],
        depoId: json["depoId"],
      );

  Map<String, dynamic> toJson() => {
        "kod": kod,
        "id": id,
        "tarih": tarih!.toIso8601String(),
        "verilenSiparisId": verilenSiparisId,
        "ozelKod1Id": ozelKod1Id,
        "ozelKod1Adi": ozelKod1Adi,
        "siparisAdi": siparisAdi,
        "aciklama": aciklama,
        "durum": durum,
        "isSeciliSiparis": isSeciliSiparis,
        "cariHesapId": cariHesapId,
        "depoId": depoId,
      };
}
