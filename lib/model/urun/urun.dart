// To parse this JSON data, do
//
//     final urun = urunFromJson(jsonString);

// List<Urun> urunFromJson(String str) => List<Urun>.from(json.decode(str).map((x) => Urun.fromJson(x)));

// String urunToJson(List<Urun> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

import 'dart:typed_data';

class Urun {
  Urun({
    required this.kod,
    required this.urunKodu,
    required this.urunAdi,
    required this.birim,
    required this.fiiliStok,
    required this.gercekStok,
    this.paketIciAdet,
    required this.fiyat,
    this.aciklama,
    // required this.durum,
    required this.id,
    this.resim,
  });

  String kod;
  String urunKodu;
  String urunAdi;
  int birim;
  int fiiliStok;
  int gercekStok;
  int? paketIciAdet;
  double fiyat;
  String? aciklama;
  // bool durum = true;
  int id;
  ByteData? resim;

  factory Urun.fromJson(Map<String, dynamic> json) => Urun(
        kod: json["kod"],
        urunKodu: json["urunKodu"],
        urunAdi: json["urunAdi"],
        birim: json["birim"],
        fiiliStok: json["fiiliStok"],
        gercekStok: json["gercekStok"],
        paketIciAdet: json["paketIciAdet"],
        fiyat: json["fiyat"].toDouble(),
        aciklama: json["aciklama"],
        // durum: json["durum"],
        id: json["id"],
        // resim: json["resim"],
      );

  Map<String, dynamic> toJson() => {
        "kod": kod,
        "urunKodu": urunKodu,
        "urunAdi": urunAdi,
        "birim": birim,
        "fiiliStok": fiiliStok,
        "gercekStok": gercekStok,
        "paketIciAdet": paketIciAdet,
        "fiyat": fiyat,
        "aciklama": aciklama,
        // "durum": durum,
        "id": id,
        // "resim": resim,
      };
}
