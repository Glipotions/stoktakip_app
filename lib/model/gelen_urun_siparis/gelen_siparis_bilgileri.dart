class GelenSiparisBilgileri {
  int? id;
  int urunId;
  int? gelenSiparisId;
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
  int? verilenSiparisBilgileriId;

  int? ilaveEdilmis;

  // Uint8List? resim;

  GelenSiparisBilgileri({
    this.id,
    required this.urunId,
    this.gelenSiparisId,
    this.verilenSiparisBilgileriId,
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
    this.ilaveEdilmis,
    // this.resim,
  });

  factory GelenSiparisBilgileri.fromJson(Map<String, dynamic> json) =>
      GelenSiparisBilgileri(
        id: json['id'],
        urunId: json['urunId'],
        gelenSiparisId: json['gelenSiparisId'],
        verilenSiparisBilgileriId: json['verilenSiparisBilgileriId'],
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
        // resim: json['resim'],
      );

  Map<String, dynamic> toJson() => {
        // 'id': id,
        'urunId': urunId,
        'gelenSiparisId': gelenSiparisId,
        'verilenSiparisBilgileriId': verilenSiparisBilgileriId,
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
        // "resim": resim,
      };

  Map<String, dynamic> toJsonWithId() => {
        'id': id,
        'urunId': urunId,
        'gelenSiparisId': gelenSiparisId,
        'verilenSiparisBilgileriId': verilenSiparisBilgileriId,
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
        // "resim": resim,
      };
}
