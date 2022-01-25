// To parse this JSON data, do
//
//     final urun = urunFromJson(jsonString);

// List<Urun> urunFromJson(String str) => List<Urun>.from(json.decode(str).map((x) => Urun.fromJson(x)));

// String urunToJson(List<Urun> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Urun {
  Urun({
    required this.kod,
    required this.urunKodu,
    required this.urunAdi,
    required this.birim,
    required this.fiiliStok,
    required this.gercekStok,
    required this.fiyat,
    this.aciklama,
    // required this.durum,
    required this.id,
  });

  String kod;
  String urunKodu;
  String urunAdi;
  int birim;
  int fiiliStok;
  int gercekStok;
  double fiyat;
  String? aciklama;
  // bool durum = true;
  int id;

  factory Urun.fromJson(Map<String, dynamic> json) => Urun(
        kod: json["kod"],
        urunKodu: json["urunKodu"],
        urunAdi: json["urunAdi"],
        birim: json["birim"],
        fiiliStok: json["fiiliStok"],
        gercekStok: json["gercekStok"],
        fiyat: json["fiyat"].toDouble(),
        aciklama: json["aciklama"],
        // durum: json["durum"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "kod": kod,
        "urunKodu": urunKodu,
        "urunAdi": urunAdi,
        "birim": birim,
        "fiiliStok": fiiliStok,
        "gercekStok": gercekStok,
        "fiyat": fiyat,
        "aciklama": aciklama,
        // "durum": durum,
        "id": id,
      };
}
