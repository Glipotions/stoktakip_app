import 'dart:convert';

class VerilenSiparisBilgileri {
  int? id;
  int urunId;

  int verilenSiparisId;
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
  int? faturayaGoreKalan;
  int? sipariseGoreKalanAdet;
  bool durum;

  // ByteData? resim;

  VerilenSiparisBilgileri({
    this.id,
    required this.urunId,
    required this.verilenSiparisId,
    required this.miktar,
    required this.birimFiyat,
    required this.dovizliBirimFiyat,
    required this.kdvHaricTutar,
    required this.kdvOrani,
    required this.kdvTutari,
    required this.tutar,
    required this.durum,
    this.urunAdi,
    this.urunKodu,
    this.insert,
    this.update,
    this.delete,
    this.iskontoOrani,
    this.dovizTuru,
    this.faturayaGoreKalan,
    this.sipariseGoreKalanAdet,
    // this.resim,
  });

  factory VerilenSiparisBilgileri.fromJson(Map<String, dynamic> json) =>
      VerilenSiparisBilgileri(
        id: json['id'],
        urunId: json['urunId'],
        verilenSiparisId: json['verilenSiparisId'],
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
        faturayaGoreKalan: json['faturayaGoreKalan'],
        sipariseGoreKalanAdet: json['sipariseGoreKalanAdet'],
        durum: json['durum'],
        // resim: json['resim'],
      );

  Map<String, dynamic> toJson() => {
        // 'id': id,
        'urunId': urunId,
        'verilenSiparisId': verilenSiparisId,
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
        "faturayaGoreKalan": faturayaGoreKalan,
        "sipariseGoreKalanAdet": sipariseGoreKalanAdet,
        "durum": durum,
        // "resim": resim,
      };

  Map<String, dynamic> toJsonWithId() => {
        'id': id,
        'urunId': urunId,
        'verilenSiparisId': verilenSiparisId,
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
        "faturayaGoreKalan": faturayaGoreKalan,
        "sipariseGoreKalanAdet": sipariseGoreKalanAdet,
        "durum": durum
        // "resim": resim,
      };
}

List<VerilenSiparisBilgileri> verilenSiparisBilgileriFromJson(String str) =>
    List<VerilenSiparisBilgileri>.from(
        json.decode(str).map((x) => VerilenSiparisBilgileri.fromJson(x)));

String verilenSiparisBilgileriToJson(List<VerilenSiparisBilgileri> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
