import 'dart:convert';

List<VerilenSiparis> satisFaturaFromJson(String str) =>
    List<VerilenSiparis>.from(
        json.decode(str).map((x) => VerilenSiparis.fromJson(x)));

String satisFaturaToJson(List<VerilenSiparis> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VerilenSiparis {
  String? kod;
  int? cariHesapId;
  int? ozelKod1Id;
  int? dovizTuru;
  double? dovizKuru;
  DateTime? tarih;
  int? kdvSekli;
  double? kdvHaricTutar;
  double? siparisKdvOrani;
  double? iskontoTutari;
  double? kdvTutari;
  double? toplamTutar;
  double? dovizTutar;
  double? iskontoOrani;
  String? aciklama;
  bool? durum;
  int? id;
  String? firmaUnvani;
  double? bakiye;
  String? tutarYazi;
  String? siparisTanimi;

  VerilenSiparis(
      {this.kod,
      this.cariHesapId,
      this.ozelKod1Id,
      this.dovizTuru,
      this.dovizKuru,
      this.tarih,
      this.kdvSekli,
      this.siparisKdvOrani,
      this.kdvHaricTutar,
      this.iskontoTutari,
      this.kdvTutari,
      this.toplamTutar,
      this.dovizTutar,
      this.iskontoOrani,
      this.aciklama,
      required this.id,
      this.firmaUnvani,
      this.bakiye,
      this.tutarYazi,
      this.siparisTanimi,
      this.durum});

  factory VerilenSiparis.fromJson(Map<String, dynamic> json) => VerilenSiparis(
        kod: json["kod"],
        cariHesapId: json["cariHesapId"],
        ozelKod1Id: json["ozelKod1Id"],
        durum: json["durum"],
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
        siparisKdvOrani: json["siparisKdvOrani"] != null
            ? json["siparisKdvOrani"].toDouble()
            : json["siparisKdvOrani"],
        kdvTutari: json["kdvTutari"] != null
            ? json["kdvTutari"].toDouble()
            : json["kdvTutari"],
        toplamTutar: json["toplamTutar"].toDouble(),
        aciklama: json["aciklama"],
        dovizTutar: json["dovizTutar"].toDouble(),
        iskontoOrani: json["iskontoOrani"] != null
            ? json["iskontoOrani"].toDouble()
            : json["iskontoOrani"],
        id: json["id"],
        firmaUnvani: json["firmaUnvani"],
        bakiye:
            json["bakiye"] != null ? json["bakiye"].toDouble() : json["bakiye"],
        tutarYazi: json["tutarYazi"],
        siparisTanimi: json["siparisTanimi"],
      );

  Map<String, dynamic> toJson() => {
        "kod": kod,
        "cariHesapId": cariHesapId,
        "ozelKod1Id": ozelKod1Id,
        "dovizTuru": dovizTuru,
        "dovizKuru": dovizKuru,
        "tarih": tarih!.toIso8601String(),
        "kdvSekli": kdvSekli,
        "siparisKdvOrani": siparisKdvOrani!.toDouble(),
        "kdvHaricTutar": kdvHaricTutar,
        "iskontoTutari": iskontoTutari,
        "kdvTutari": kdvTutari,
        "toplamTutar": toplamTutar,
        "dovizTutar": dovizTutar,
        "iskontoOrani": iskontoOrani,
        "aciklama": aciklama,
        "durum": durum,
        "id": id,
        "firmaUnvani": firmaUnvani,
        "bakiye": bakiye,
        "tutarYazi": tutarYazi,
        "siparisTanimi": siparisTanimi,
      };
}
