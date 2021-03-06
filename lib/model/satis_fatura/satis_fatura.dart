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
  double? faturaKdvOrani;
  double? iskontoTutari;
  double? kdvTutari;
  double? toplamTutar;
  double? dovizTutar;
  double? iskontoOrani;
  String? aciklama;
  int odemeTipi;
  bool? durum;
  int id;
  String? firmaUnvani;
  double? bakiye;
  String? tutarYazi;

  SatisFatura({
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
    this.durum,
    required this.id,
    this.firmaUnvani,
    this.bakiye,
    this.tutarYazi,
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
        kdvHaricTutar: json["kdvHaricTutar"] != null
            ? json["kdvHaricTutar"].toDouble()
            : json["kdvHaricTutar"],
        iskontoTutari: json["iskontoTutari"] != null
            ? json["iskontoTutari"].toDouble()
            : json["iskontoTutari"],
        faturaKdvOrani: json["faturaKdvOrani"] != null
            ? json["faturaKdvOrani"].toDouble()
            : json["faturaKdvOrani"],
        kdvTutari: json["kdvTutari"] != null
            ? json["kdvTutari"].toDouble()
            : json["kdvTutari"],
        toplamTutar: json["toplamTutar"].toDouble(),
        aciklama: json["aciklama"],
        dovizTutar: json["dovizTutar"].toDouble(),
        iskontoOrani: json["iskontoOrani"] != null
            ? json["iskontoOrani"].toDouble()
            : json["iskontoOrani"],
        odemeTipi: json["odemeTipi"],
        durum: json["durum"],
        id: json["id"],
        firmaUnvani: json["firmaUnvani"],
        bakiye:
            json["bakiye"] != null ? json["bakiye"].toDouble() : json["bakiye"],
        tutarYazi: json["tutarYazi"],
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
        "faturaKdvOrani": faturaKdvOrani!.toDouble(),
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
        "firmaUnvani": firmaUnvani,
        "bakiye": bakiye,
        "tutarYazi": tutarYazi,
      };
}
