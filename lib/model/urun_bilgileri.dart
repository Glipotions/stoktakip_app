class UrunBilgileri {
  int urunId;
  int satisFaturaId;
  int miktar;
  double dovizliBirimFiyat;
  double kdvHaricTutar;
  int kdvOrani;
  double kdvTutari;
  double tutar;
  String? urunAdi;

  UrunBilgileri(
      {required this.urunId,
      required this.satisFaturaId,
      required this.miktar,
      required this.dovizliBirimFiyat,
      required this.kdvHaricTutar,
      required this.kdvOrani,
      required this.kdvTutari,
      required this.tutar,
      this.urunAdi});

  factory UrunBilgileri.fromJson(Map<String, dynamic> json) => UrunBilgileri(
        urunId: json['urunId'],
        satisFaturaId: json['satisFaturaId'],
        miktar: json['miktar'],
        dovizliBirimFiyat: json['dovizliBirimFiyat'],
        kdvHaricTutar: json['kdvHaricTutar'],
        kdvOrani: json['kdvOrani'],
        kdvTutari: json['kdvTutari'],
        tutar: json['tutar'],
      );

  Map<String, dynamic> toJson() => {
        'urunId': urunId,
        'satisFaturaId': satisFaturaId,
        'miktar': miktar,
        'dovizliBirimFiyat': dovizliBirimFiyat,
        'kdvHaricTutar': kdvHaricTutar,
        'kdvOrani': kdvOrani,
        'kdvTutari': kdvTutari,
        'tutar': tutar,
      };
}

List<UrunBilgileri> urunBilgileriList = [];
