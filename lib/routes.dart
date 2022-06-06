import 'package:flutter/widgets.dart';
import 'package:stoktakip_app/screens/cart_satis_fatura_duzenle/cart_screen.dart';
import 'package:stoktakip_app/screens/fatura_olustur/fatura_olustur.dart';
import 'package:stoktakip_app/screens/cart_satis_fatura/cart_screen.dart';
import 'package:stoktakip_app/screens/gelen_urun_siparisi/cart_gelen_siparis/cart_screen.dart';
import 'package:stoktakip_app/screens/gelen_urun_siparisi/gelen_siparis_bilgileri/gelen_siparis_bilgileri_add.dart';
import 'package:stoktakip_app/screens/gelen_urun_siparisi/gelen_siparis_list/list_screen_gelen_siparis.dart';
import 'package:stoktakip_app/screens/gelen_urun_siparisi/gelen_siparis_hazirla.dart';
import 'package:stoktakip_app/screens/gelen_urun_siparisi/siparisi_goruntule/gelen_siparisi_goruntule_list.dart';
import 'package:stoktakip_app/screens/home/home_view.dart';
import 'package:stoktakip_app/screens/satis_fatura_list/list_screen_satis_fatura.dart';
import 'package:stoktakip_app/screens/shared_settings/settings_page.dart';
import 'package:stoktakip_app/screens/siparis_hazirla/cart_hazirlanan_siparis/cart_screen.dart';
import 'package:stoktakip_app/screens/siparis_hazirla/hazirlanan_siparis_bilgileri/hazirlanan_siparis_bilgileri_add.dart';
import 'package:stoktakip_app/screens/siparis_hazirla/hazirlanan_siparis_list/list_screen_hazirlanan_siparis.dart';
import 'package:stoktakip_app/screens/siparis_hazirla/siparis_hazirla.dart';
import 'package:stoktakip_app/screens/siparis_hazirla/siparisi_goruntule/siparisi_goruntule_list.dart';
import 'package:stoktakip_app/screens/urun_bilgileri/urun_bilgileri_add.dart';
import 'package:stoktakip_app/screens/urun_bilgileri_duzenle/urun_bilgileri_duzenle_add.dart';

import 'screens/cart_satin_alma_fatura/cart_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  HomeViewPage.routeName: (context) => const HomeViewPage(),

  CartScreenSatisFatura.routeName: (context) => const CartScreenSatisFatura(),
  CartScreenSatisFaturaDuzenle.routeName: (context) =>
      const CartScreenSatisFaturaDuzenle(),
  CartScreenSatinAlmaFatura.routeName: (context) =>
      const CartScreenSatinAlmaFatura(),
  CartScreenHazirlananSiparis.routeName: (context) =>
      const CartScreenHazirlananSiparis(),
  CartScreenGelenSiparis.routeName: (context) => const CartScreenGelenSiparis(),

  UrunBilgileriAdd.routeName: (context) => UrunBilgileriAdd(),
  UrunBilgileriDuzenleAdd.routeName: (context) => UrunBilgileriDuzenleAdd(),
  HazirlananSiparisBilgileriAdd.routeName: (context) =>
      HazirlananSiparisBilgileriAdd(),
  GelenSiparisBilgileriAdd.routeName: (context) => GelenSiparisBilgileriAdd(),

  FaturaOlustur.routeName: (context) => const FaturaOlustur(),
  SiparisHazirla.routeName: (context) => const SiparisHazirla(),
  GelenSiparisHazirla.routeName: (context) => const GelenSiparisHazirla(),

  ListScreenSatisFatura.routeName: (context) => const ListScreenSatisFatura(),
  ListScreenHazirlananSiparis.routeName: (context) =>
      const ListScreenHazirlananSiparis(),
  ListScreenGelenSiparis.routeName: (context) => const ListScreenGelenSiparis(),
  ListSiparisiGoruntuleTable.routeName: (context) =>
      const ListSiparisiGoruntuleTable(),
  ListGelenSiparisiGoruntuleTable.routeName: (context) =>
      const ListGelenSiparisiGoruntuleTable(),

  SettingsPage.routeName: (context) => const SettingsPage(),
  // ProfileScreen.routeName: (context) => ProfileScreen(),
};
