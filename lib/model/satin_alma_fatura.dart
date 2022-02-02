import 'dart:convert';

List<SatinAlmaFatura> satinAlmaFaturaFromJson(String str) =>
    List<SatinAlmaFatura>.from(
        json.decode(str).map((x) => SatinAlmaFatura.fromJson(x)));

String satinAlmaFaturaToJson(List<SatinAlmaFatura> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SatinAlmaFatura {
  String? kod;
  int cariHesapId;
  int? ozelKod1Id;
  int faturaTuru;
  int dovizTuru;
  double dovizKuru;
  DateTime tarih;
  int kdvSekli;
  double? kdvHaricTutar;
  int? faturaKdvOrani;
  double? iskontoTutari;
  double? kdvTutari;
  double? toplamTutar;
  double? dovizTutar;
  double? iskontoOrani;
  String? aciklama;
  int odemeTipi;
  bool durum;
  int id;

  SatinAlmaFatura({
    this.kod,
    required this.cariHesapId,
    this.ozelKod1Id,
    required this.faturaTuru,
    required this.dovizTuru,
    required this.dovizKuru,
    required this.tarih,
    required this.kdvSekli,
    this.faturaKdvOrani,
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

  factory SatinAlmaFatura.fromJson(Map<String, dynamic> json) =>
      SatinAlmaFatura(
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
        faturaKdvOrani: json["faturaKdvOrani"].toDouble(),
        kdvTutari: json["kdvTutari"].toDouble(),
        toplamTutar: json["toplamTutar"].toDouble(),
        aciklama: json["aciklama"],
        dovizTutar: json["dovizTutar"].toDouble(),
        iskontoOrani: json["iskontoOrani"].toDouble(),
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
        "faturaKdvOrani": faturaKdvOrani,
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
