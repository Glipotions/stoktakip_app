class UrunBilgileri {
  int? id;
  int urunId;
  int satisFaturaId;
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

  UrunBilgileri({
    this.id,
    required this.urunId,
    required this.satisFaturaId,
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
  });

  factory UrunBilgileri.fromJson(Map<String, dynamic> json) => UrunBilgileri(
      id: json['id'],
      urunId: json['urunId'],
      satisFaturaId: json['satisFaturaId'],
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
      iskontoOrani: json['iskontoOrani']);

  Map<String, dynamic> toJson() => {
        // 'id': id,
        'urunId': urunId,
        'satisFaturaId': satisFaturaId,
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
      };

  Map<String, dynamic> toJsonWithId() => {
        'id': id,
        'urunId': urunId,
        'satisFaturaId': satisFaturaId,
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
      };
}

List<UrunBilgileri> urunBilgileriList = [];
List<UrunBilgileri> urunBilgileriGetIdList = [];
List<UrunBilgileri> urunBilgileriDeleteList = [];
