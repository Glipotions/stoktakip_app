import 'package:flutter/widgets.dart';
import 'package:stoktakip_app/screens/cart_satis_fatura_duzenle/cart_screen.dart';
import 'package:stoktakip_app/screens/fatura_olustur/fatura_olustur.dart';
import 'package:stoktakip_app/screens/cart_satis_fatura/cart_screen.dart';
import 'package:stoktakip_app/screens/satis_fatura_list/list_screen_satis_fatura.dart';
import 'package:stoktakip_app/screens/shared_settings/settings_page.dart';
import 'package:stoktakip_app/screens/urun_bilgileri/urun_bilgileri_add.dart';
import 'package:stoktakip_app/screens/urun_bilgileri_duzenle/urun_bilgileri_duzenle_add.dart';

import 'screens/cart_satin_alma_fatura/cart_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  CartScreenSatisFatura.routeName: (context) => const CartScreenSatisFatura(),
  CartScreenSatisFaturaDuzenle.routeName: (context) =>
      const CartScreenSatisFaturaDuzenle(),
  CartScreenSatinAlmaFatura.routeName: (context) =>
      const CartScreenSatinAlmaFatura(),
  ListScreenSatisFatura.routeName: (context) => const ListScreenSatisFatura(),
  UrunBilgileriAdd.routeName: (context) => UrunBilgileriAdd(),
  UrunBilgileriDuzenleAdd.routeName: (context) => UrunBilgileriDuzenleAdd(),
  FaturaOlustur.routeName: (context) => const FaturaOlustur(),

  SettingsPage.routeName: (context) => SettingsPage(),
  // ProfileScreen.routeName: (context) => ProfileScreen(),
};
