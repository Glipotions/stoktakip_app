import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stoktakip_app/change_notifier_model/alinan_siparis_bilgileri_data.dart';
import 'package:stoktakip_app/change_notifier_model/gelen_siparis_bilgileri_data.dart';
import 'package:stoktakip_app/change_notifier_model/hazirlanan_siparis_bilgileri_data.dart';
import 'package:stoktakip_app/change_notifier_model/kasa_data.dart';
import 'package:stoktakip_app/change_notifier_model/kdv_data.dart';
import 'package:stoktakip_app/change_notifier_model/verilen_siparis_bilgileri_data.dart';
import 'package:stoktakip_app/routes.dart';
import 'package:stoktakip_app/screens/login/host_page.dart';
import 'package:stoktakip_app/theme.dart';

import 'change_notifier_model/ip_host_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await KdvData().createPrefObject();
  await KasaData().createPrefObject();
  await IpHostData().createPrefObject();
  await AlinanSiparisBilgileriData().createPrefObject();
  await HazirlananSiparisBilgileriData().createPrefObject();
  await VerilenSiparisBilgileriData().createPrefObject();
  await GelenSiparisBilgileriData().createPrefObject();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<KdvData>(
        create: (BuildContext context) => KdvData()),
    ChangeNotifierProvider<KasaData>(
        create: (BuildContext context) => KasaData()),
    ChangeNotifierProvider<IpHostData>(
        create: (BuildContext context) => IpHostData()),
    ChangeNotifierProvider<AlinanSiparisBilgileriData>(
        create: (BuildContext context) => AlinanSiparisBilgileriData()),
    ChangeNotifierProvider<HazirlananSiparisBilgileriData>(
        create: (BuildContext context) => HazirlananSiparisBilgileriData()),
    ChangeNotifierProvider<VerilenSiparisBilgileriData>(
        create: (BuildContext context) => VerilenSiparisBilgileriData()),
    ChangeNotifierProvider<GelenSiparisBilgileriData>(
        create: (BuildContext context) => GelenSiparisBilgileriData()),
  ], child: const MyApp()));
  HttpOverrides.global = MyHttpOverrides();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Provider.of<KdvData>(context).loadKdvToSharedPref();
    Provider.of<KasaData>(context).loadKasaToSharedPref();
    Provider.of<AlinanSiparisBilgileriData>(context).getList();
    Provider.of<HazirlananSiparisBilgileriData>(context).getList();
    Provider.of<VerilenSiparisBilgileriData>(context).getList();
    Provider.of<GelenSiparisBilgileriData>(context).getList();
    return MaterialApp(
      title: 'Glipotions Stok Takip Uygulaması',
      theme: theme(),
      home: const HostPage(),
      routes: routes,
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
