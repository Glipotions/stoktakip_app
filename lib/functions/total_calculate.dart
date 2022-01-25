import 'package:stoktakip_app/model/urun_bilgileri.dart';

// class TotalCalc {
//   UrunBilgileri _urunBilgileri;
//   TotalCalc(this._urunBilgileri);
// }
double sonuc = 0;

double kdvHesapla(List<UrunBilgileri> urun, double iskonto) {
  for (var i = 0; i < urun.length; i++) {
    sonuc = iskontoluTutariHesapla(urun, iskonto) * urun[i].kdvOrani / 100;
  }
  return sonuc;
}

double totalTutarHesapla(List<UrunBilgileri> urun) {
  sonuc = 0;
  for (var i = 0; i < urun.length; i++) {
    sonuc += urun[i].kdvHaricTutar;
  }
  return sonuc;
}

double iskontoTutarHesap(List<UrunBilgileri> urun, double iskontoOrani) {
  return sonuc = (totalTutarHesapla(urun) * iskontoOrani) / 100;
}

double iskontoluTutariHesapla(List<UrunBilgileri> urun, double iskontoOrani) {
  return sonuc =
      totalTutarHesapla(urun) - iskontoTutarHesap(urun, iskontoOrani);
}

double totalTutarwithKdv(List<UrunBilgileri> urun, double iskontoOrani) {
  for (var i = 0; i < urun.length; i++) {
    sonuc = iskontoluTutariHesapla(urun, iskontoOrani) +
        iskontoluTutariHesapla(urun, iskontoOrani) * urun[i].kdvOrani / 100;
  }
  return sonuc;
}
