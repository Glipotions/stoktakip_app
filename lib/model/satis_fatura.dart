import 'dart:convert';

List<SatisFatura> satisFaturaFromJson(String str) => List<SatisFatura>.from(
    json.decode(str).map((x) => SatisFatura.fromJson(x)));

String satisFaturaToJson(List<SatisFatura> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SatisFatura {
  String? kod;
  int cariHesapId;
  int? ozelKod1Id;
  int faturaTuru;
  int dovizTuru;
  double dovizKuru;
  DateTime tarih;
  int kdvSekli;
  double? kdvHaricTutar;
  double? iskontoTutari;
  double? kdvTutari;
  double? toplamTutar;
  double? dovizTutar;
  int? iskontoOrani;
  String? aciklama;
  int odemeTipi;
  bool durum;
  int id;

  SatisFatura({
    this.kod,
    required this.cariHesapId,
    this.ozelKod1Id,
    required this.faturaTuru,
    required this.dovizTuru,
    required this.dovizKuru,
    required this.tarih,
    required this.kdvSekli,
    this.kdvHaricTutar,
    this.iskontoTutari,
    this.kdvTutari,
    this.toplamTutar,
    this.dovizTutar,
    this.iskontoOrani,
    this.aciklama,
    required this.odemeTipi,
    required this.durum,
    required this.id,
  });

  factory SatisFatura.fromJson(Map<String, dynamic> json) => SatisFatura(
        kod: json["kod"],
        cariHesapId: json["cariHesapId"],
        ozelKod1Id: json["ozelKod1Id"],
        faturaTuru: json["faturaTuru"],
        dovizTuru: json["dovizTuru"],
        dovizKuru: json["dovizKuru"].toDouble(),
        tarih: DateTime.parse(json["tarih"]),
        kdvSekli: json["kdvSekli"],
        kdvHaricTutar: json["kdvHaricTutar"].toDouble(),
        iskontoTutari: json["iskontoTutari"].toDouble(),
        kdvTutari: json["kdvTutari"].toDouble(),
        toplamTutar: json["toplamTutar"].toDouble(),
        aciklama: json["aciklama"],
        dovizTutar: json["dovizTutar"].toDouble(),
        iskontoOrani: json["iskontoOrani"],
        odemeTipi: json["odemeTipi"],
        durum: json["durum"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "kod": kod,
        "cariHesapId": cariHesapId,
        "ozelKod1Id": ozelKod1Id,
        "faturaTuru": faturaTuru,
        "dovizTuru": dovizTuru,
        "dovizKuru": dovizKuru,
        "tarih": tarih.toIso8601String(),
        "kdvSekli": kdvSekli,
        "kdvHaricTutar": kdvHaricTutar,
        "iskontoTutari": iskontoTutari,
        "kdvTutari": kdvTutari,
        "toplamTutar": toplamTutar,
        "dovizTutar": dovizTutar,
        "iskontoOrani": iskontoOrani,
        "aciklama": aciklama,
        "odemeTipi": odemeTipi,
        "durum": durum,
        "id": id,
      };
}

SatisFatura satisFaturaNew = SatisFatura(
    cariHesapId: 1,
    // kod: "Deneme-0001",
    aciklama: "Mobil Satış",
    faturaTuru: 3,
    dovizTuru: 1,
    dovizKuru: 1,
    tarih: DateTime.now(),
    kdvSekli: 1,
    odemeTipi: 0,
    durum: true,
    id: 1);
