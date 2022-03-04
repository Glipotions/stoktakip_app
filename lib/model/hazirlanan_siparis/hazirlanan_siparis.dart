import 'dart:convert';

List<HazirlananSiparis> satisFaturaFromJson(String str) =>
    List<HazirlananSiparis>.from(
        json.decode(str).map((x) => HazirlananSiparis.fromJson(x)));

String satisFaturaToJson(List<HazirlananSiparis> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HazirlananSiparis {
  int? id;
  String? kod;
  int? alinanSiparisId;
  DateTime? tarih;
  String? siparisAdi;
  int? ozelKod1Id;
  String? ozelKod1Adi;
  String? aciklama;
  bool? durum = true;

  // int? cariHesapId;
  // int? ozelKod1Id;
  // int? dovizTuru;
  // double? dovizKuru;
  // int? kdvSekli;
  // double? kdvHaricTutar;
  // double? siparisKdvOrani;
  // double? iskontoTutari;
  // double? kdvTutari;
  // double? toplamTutar;
  // double? dovizTutar;
  // double? iskontoOrani;
  // // int? odemeTipi;
  // bool? durum;
  // String? firmaUnvani;
  // double? bakiye;
  // String? tutarYazi;

  HazirlananSiparis({
    this.kod,
    this.tarih,
    this.id,
    this.alinanSiparisId,
    this.siparisAdi,
    this.ozelKod1Id,
    this.ozelKod1Adi,
    this.aciklama,
    this.durum,
    // this.cariHesapId,
    // this.ozelKod1Id,
    // this.dovizTuru,
    // this.dovizKuru,
    // this.kdvSekli,
    // this.siparisKdvOrani,
    // this.kdvHaricTutar,
    // this.iskontoTutari,
    // this.kdvTutari,
    // this.toplamTutar,
    // this.dovizTutar,
    // this.iskontoOrani,
    // this.durum,
    // this.firmaUnvani,
    // this.bakiye,
    // this.tutarYazi,
  });

  factory HazirlananSiparis.fromJson(Map<String, dynamic> json) =>
      HazirlananSiparis(
        kod: json["kod"],
        tarih: DateTime.parse(json["tarih"]),
        id: json["id"],
        alinanSiparisId: json["alinanSiparisId"],
        ozelKod1Id: json["ozelKod1Id"],
        ozelKod1Adi: json["ozelKod1Adi"],
        siparisAdi: json["siparisAdi"],
        aciklama: json["aciklama"],
        durum: json["durum"],
        // cariHesapId: json["cariHesapId"],
        // ozelKod1Id: json["ozelKod1Id"],
        // dovizTuru: json["dovizTuru"],
        // dovizKuru: json["dovizKuru"].toDouble(),
        // kdvSekli: json["kdvSekli"],
        // kdvHaricTutar: json["kdvHaricTutar"] != null
        //     ? json["kdvHaricTutar"].toDouble()
        //     : json["kdvHaricTutar"],
        // iskontoTutari: json["iskontoTutari"] != null
        //     ? json["iskontoTutari"].toDouble()
        //     : json["iskontoTutari"],
        // siparisKdvOrani: json["faturaKdvOrani"] != null
        //     ? json["faturaKdvOrani"].toDouble()
        //     : json["faturaKdvOrani"],
        // kdvTutari: json["kdvTutari"] != null
        //     ? json["kdvTutari"].toDouble()
        //     : json["kdvTutari"],
        // toplamTutar: json["toplamTutar"].toDouble(),
        // dovizTutar: json["dovizTutar"].toDouble(),
        // iskontoOrani: json["iskontoOrani"] != null
        //     ? json["iskontoOrani"].toDouble()
        //     : json["iskontoOrani"],
        // durum: json["durum"],
        // firmaUnvani: json["firmaUnvani"],
        // bakiye:
        //     json["bakiye"] != null ? json["bakiye"].toDouble() : json["bakiye"],
        // tutarYazi: json["tutarYazi"],
      );

  Map<String, dynamic> toJson() => {
        "kod": kod,
        "id": id,
        "tarih": tarih!.toIso8601String(),
        "alinanSiparisId": alinanSiparisId,
        "ozelKod1Id": ozelKod1Id,
        "ozelKod1Adi": ozelKod1Adi,
        "siparisAdi": siparisAdi,
        "aciklama": aciklama,
        "durum": durum,
        // "cariHesapId": cariHesapId,
        // "ozelKod1Id": ozelKod1Id,
        // "dovizTuru": dovizTuru,
        // "dovizKuru": dovizKuru,
        // "kdvSekli": kdvSekli,
        // "faturaKdvOrani": siparisKdvOrani!.toDouble(),
        // "kdvHaricTutar": kdvHaricTutar,
        // "iskontoTutari": iskontoTutari,
        // "kdvTutari": kdvTutari,
        // "toplamTutar": toplamTutar,
        // "dovizTutar": dovizTutar,
        // "iskontoOrani": iskontoOrani,
        // "durum": durum,
        // "firmaUnvani": firmaUnvani,
        // "bakiye": bakiye,
        // "tutarYazi": tutarYazi,
      };
}
