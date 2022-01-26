import 'package:stoktakip_app/model/urun_bilgileri.dart';
import 'package:stoktakip_app/model/urun_bilgileri_satin_alma.dart';

// class TotalCalc {
//   UrunBilgileri _UrunBilgileri;
//   TotalCalc(this._UrunBilgileri);
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

//-----------------------------------------------------------------------------
double kdvHesaplaSatinAlma(List<UrunBilgileriSatinAlma> urun, double iskonto) {
  for (var i = 0; i < urun.length; i++) {
    sonuc =
        iskontoluTutariHesaplaSatinAlma(urun, iskonto) * urun[i].kdvOrani / 100;
  }
  return sonuc;
}

double totalTutarHesaplaSatinAlma(List<UrunBilgileriSatinAlma> urun) {
  sonuc = 0;
  for (var i = 0; i < urun.length; i++) {
    sonuc += urun[i].kdvHaricTutar;
  }
  return sonuc;
}

double iskontoTutarHesapSatinAlma(
    List<UrunBilgileriSatinAlma> urun, double iskontoOrani) {
  return sonuc = (totalTutarHesaplaSatinAlma(urun) * iskontoOrani) / 100;
}

double iskontoluTutariHesaplaSatinAlma(
    List<UrunBilgileriSatinAlma> urun, double iskontoOrani) {
  return sonuc = totalTutarHesaplaSatinAlma(urun) -
      iskontoTutarHesapSatinAlma(urun, iskontoOrani);
}

double totalTutarwithKdvSatinAlma(
    List<UrunBilgileriSatinAlma> urun, double iskontoOrani) {
  for (var i = 0; i < urun.length; i++) {
    sonuc = iskontoluTutariHesaplaSatinAlma(urun, iskontoOrani) +
        iskontoluTutariHesaplaSatinAlma(urun, iskontoOrani) *
            urun[i].kdvOrani /
            100;
  }
  return sonuc;
}
