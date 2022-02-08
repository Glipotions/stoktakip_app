class UrunBilgileri {
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

  UrunBilgileri(
      {required this.urunId,
      required this.satisFaturaId,
      required this.miktar,
      required this.birimFiyat,
      required this.dovizliBirimFiyat,
      required this.kdvHaricTutar,
      required this.kdvOrani,
      required this.kdvTutari,
      required this.tutar,
      this.urunAdi,
      this.urunKodu});

  factory UrunBilgileri.fromJson(Map<String, dynamic> json) => UrunBilgileri(
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
      );

  Map<String, dynamic> toJson() => {
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
      };
}

List<UrunBilgileri> urunBilgileriList = [];
List<UrunBilgileri> urunBilgileriGetIdList = [];
