import 'dart:typed_data';

class HazirlananSiparisBilgileri {
  int? id;
  int urunId;
  int? hazirlananSiparisId;
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
  Uint8List? resim;

  HazirlananSiparisBilgileri({
    this.id,
    required this.urunId,
    this.hazirlananSiparisId,
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
    this.resim,
  });

  factory HazirlananSiparisBilgileri.fromJson(Map<String, dynamic> json) =>
      HazirlananSiparisBilgileri(
        id: json['id'],
        urunId: json['urunId'],
        hazirlananSiparisId: json['hazirlananSiparisId'],
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
        resim: json['resim'],
      );

  Map<String, dynamic> toJson() => {
        // 'id': id,
        'urunId': urunId,
        'hazirlananSiparisId': hazirlananSiparisId,
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
        "resim": resim,
      };

  Map<String, dynamic> toJsonWithId() => {
        'id': id,
        'urunId': urunId,
        'hazirlananSiparisId': hazirlananSiparisId,
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
        "resim": resim,
      };
}
