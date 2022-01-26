import 'package:stoktakip_app/model/satis_fatura.dart';
import 'package:stoktakip_app/model/satin_alma_fatura.dart';

bool? faturaDurum;

SatisFatura satisFaturaNew = SatisFatura(
    cariHesapId: 1,
    kod: "Deneme-0001",
    aciklama: "Mobil Satış",
    faturaTuru: 3,
    dovizTuru: 1,
    dovizKuru: 1,
    tarih: DateTime.now(),
    kdvSekli: 1,
    odemeTipi: 0,
    durum: true,
    id: 1);

SatinAlmaFatura satinAlmaFaturaNew = SatinAlmaFatura(
    cariHesapId: 1,
    kod: "Deneme-0001",
    aciklama: "Mobil Satın Alma",
    faturaTuru: 1,
    dovizTuru: 1,
    dovizKuru: 1,
    tarih: DateTime.now(),
    kdvSekli: 1,
    odemeTipi: 0,
    durum: true,
    id: 1);
