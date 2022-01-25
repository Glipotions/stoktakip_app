import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stoktakip_app/model/kdv_data.dart';
import 'package:stoktakip_app/routes.dart';
import 'package:stoktakip_app/screens/fatura_olustur/fatura_olustur.dart';
import 'package:stoktakip_app/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await KdvData().createPrefObject();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<KdvData>(create: (BuildContext context) => KdvData())
  ], child: MyApp()));
  HttpOverrides.global = MyHttpOverrides();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Provider.of<KdvData>(context).loadKdvToSharedPref();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme(),
      home: FaturaOlustur(),
      initialRoute: FaturaOlustur.routeName,
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
