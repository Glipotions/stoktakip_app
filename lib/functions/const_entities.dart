import 'package:stoktakip_app/model/alinan_siparis/alinan_siparis.dart';
import 'package:stoktakip_app/model/alinan_siparis/alinan_siparis_bilgileri.dart';
import 'package:stoktakip_app/model/hazirlanan_siparis/hazirlanan_siparis.dart';
import 'package:stoktakip_app/model/hazirlanan_siparis/hazirlanan_siparis_bilgileri.dart';
import 'package:stoktakip_app/model/kasa/kasa.dart';
import 'package:stoktakip_app/model/nakit/nakit.dart';
import 'package:stoktakip_app/model/satis_fatura/satis_fatura.dart';
import '../model/satin_alma/satin_alma_fatura.dart';

bool? faturaDurum, hazirlananSiparisDurum;

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

Nakit nakitEntity = Nakit(
    dovizliTutar: 0,
    id: 0,
    tutar: 0,
    cariHesapId: 0,
    cariHesapTuru: 2,
    dovizTuru: 1,
    kasaId: 0,
    aciklama: null,
    kod: "Mobil-0001",
    makbuzNo: null,
    yaziIleTutar: "");

Kasa kasaEntity = Kasa(bakiye: 0, id: 0, kasaAdi: "-");

String? faturaAciklama, siparisAciklama;

AlinanSiparis alinanSiparisSingle = AlinanSiparis(id: -1);
List<AlinanSiparis> alinanSiparisList = [];
String? alinanSiparisBilgileriControlString;
List<AlinanSiparisBilgileri> alinanSiparisBilgileriList = [];
List<AlinanSiparisBilgileri> alinanSiparisBilgileriGetIdList = [];
List<AlinanSiparisBilgileri> alinanSiparisBilgileriDeleteList = [];

HazirlananSiparis hazirlananSiparisSingle = HazirlananSiparis();
HazirlananSiparis hazirlananSiparisEdit = HazirlananSiparis();
List<HazirlananSiparisBilgileri> hazirlananSiparisBilgileriList = [];
List<HazirlananSiparisBilgileri> hazirlananSiparisBilgileriGetIdList = [];
List<HazirlananSiparisBilgileri> hazirlananSiparisBilgileriDeleteList = [];
