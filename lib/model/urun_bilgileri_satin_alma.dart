import 'entity.dart';

class UrunBilgileriSatinAlma implements FaturaBilgileriEntity {
  int urunId;
  int satinAlmaFaturaId;
  int miktar;
  double birimFiyat;
  double dovizliBirimFiyat;
  double kdvHaricTutar;
  int kdvOrani;
  double kdvTutari;
  double tutar;
  String? urunAdi;
  String? urunKodu;

  UrunBilgileriSatinAlma(
      {required this.urunId,
      required this.satinAlmaFaturaId,
      required this.miktar,
      required this.birimFiyat,
      required this.dovizliBirimFiyat,
      required this.kdvHaricTutar,
      required this.kdvOrani,
      required this.kdvTutari,
      required this.tutar,
      this.urunAdi,
      this.urunKodu});

  factory UrunBilgileriSatinAlma.fromJson(Map<String, dynamic> json) =>
      UrunBilgileriSatinAlma(
        urunId: json['urunId'],
        satinAlmaFaturaId: json['satinAlmaFaturaId'],
        miktar: json['miktar'],
        birimFiyat: json['birimFiyat'],
        dovizliBirimFiyat: json['dovizliBirimFiyat'],
        kdvHaricTutar: json['kdvHaricTutar'],
        kdvOrani: json['kdvOrani'],
        kdvTutari: json['kdvTutari'],
        tutar: json['tutar'],
      );

  Map<String, dynamic> toJson() => {
        'urunId': urunId,
        'satinAlmaFaturaId': satinAlmaFaturaId,
        'miktar': miktar,
        'birimFiyat': birimFiyat,
        'dovizliBirimFiyat': dovizliBirimFiyat,
        'kdvHaricTutar': kdvHaricTutar,
        'kdvOrani': kdvOrani,
        'kdvTutari': kdvTutari,
        'tutar': tutar,
      };
}

List<UrunBilgileriSatinAlma> urunBilgileriSatinAlmaList = [];
