import 'package:flutter/services.dart';

class AlinanSiparisBilgileri {
  int? id;
  int urunId;

  int alinanSiparisId;
  int miktar;
  double birimFiyat;
  double dovizliBirimFiyat;
  double kdvHaricTutar;

  double kdvOrani;
  double kdvTutari;
  double tutar;
  String? urunAdi;
  String? urunKodu;

  bool? insert = false;
  bool? update = false;
  bool? delete = false;
  int? dovizTuru = 1;
  double? iskontoOrani = 0;
  int? kalanMiktar;

  // ByteData? resim;

  AlinanSiparisBilgileri({
    this.id,
    required this.urunId,
    required this.alinanSiparisId,
    required this.miktar,
    required this.birimFiyat,
    required this.dovizliBirimFiyat,
    required this.kdvHaricTutar,
    required this.kdvOrani,
    required this.kdvTutari,
    required this.tutar,
    this.urunAdi,
    this.urunKodu,
    this.insert,
    this.update,
    this.delete,
    this.iskontoOrani,
    this.dovizTuru,
    this.kalanMiktar,
    // this.resim,
  });

  factory AlinanSiparisBilgileri.fromJson(Map<String, dynamic> json) =>
      AlinanSiparisBilgileri(
        id: json['id'],
        urunId: json['urunId'],
        alinanSiparisId: json['alinanSiparisId'],
        miktar: json['miktar'],
        birimFiyat: json['birimFiyat'],
        dovizliBirimFiyat: json['dovizliBirimFiyat'],
        kdvHaricTutar: json['kdvHaricTutar'],
        kdvOrani: json['kdvOrani'],
        kdvTutari: json['kdvTutari'],
        tutar: json['tutar'],
        urunAdi: json['urunAdi'],
        urunKodu: json['urunKodu'],
        insert: json['insert'],
        update: json['update'],
        delete: json['delete'],
        iskontoOrani: json['iskontoOrani'],
        kalanMiktar: json['kalanMiktar'],
        // resim: json['resim'],
      );

  Map<String, dynamic> toJson() => {
        // 'id': id,
        'urunId': urunId,
        'alinanSiparisId': alinanSiparisId,
        'miktar': miktar,
        'birimFiyat': birimFiyat,
        'dovizliBirimFiyat': dovizliBirimFiyat,
        'kdvHaricTutar': kdvHaricTutar,
        'kdvOrani': kdvOrani,
        'kdvTutari': kdvTutari,
        'tutar': tutar,
        'urunKodu': urunKodu,
        'urunAdi': urunAdi,
        "insert": insert,
        "update": update,
        "delete": delete,
        "iskontoOrani": iskontoOrani,
        "dovizTuru": dovizTuru,
        "kalanMiktar": kalanMiktar,
        // "resim": resim,
      };

  Map<String, dynamic> toJsonWithId() => {
        'id': id,
        'urunId': urunId,
        'alinanSiparisId': alinanSiparisId,
        'miktar': miktar,
        'birimFiyat': birimFiyat,
        'dovizliBirimFiyat': dovizliBirimFiyat,
        'kdvHaricTutar': kdvHaricTutar,
        'kdvOrani': kdvOrani,
        'kdvTutari': kdvTutari,
        'tutar': tutar,
        'urunKodu': urunKodu,
        'urunAdi': urunAdi,
        "insert": insert,
        "update": update,
        "delete": delete,
        "iskontoOrani": iskontoOrani,
        "dovizTuru": dovizTuru,
        "kalanMiktar": kalanMiktar,
        // "resim": resim,
      };
}
