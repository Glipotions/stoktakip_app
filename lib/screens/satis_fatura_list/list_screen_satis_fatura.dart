import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stoktakip_app/functions/const_entities.dart';
import 'package:stoktakip_app/model/satis_fatura.dart';
import 'package:stoktakip_app/screens/shared_settings/settings_page.dart';
import 'package:stoktakip_app/services/api.services.dart';
// import 'package:shop_app/models/Cart.dart';

import 'components/body.dart';

class ListScreenSatisFatura extends StatefulWidget {
  static String routeName = "/satisfaturalist";

  const ListScreenSatisFatura({Key? key}) : super(key: key);

  @override
  State<ListScreenSatisFatura> createState() => _ListScreenSatisFaturaState();
}

class _ListScreenSatisFaturaState extends State<ListScreenSatisFatura> {
  @override
  Widget build(BuildContext context) {
    return const Body();
    // return Scaffold(
    //   appBar: buildAppBar(context),
    //   body: const Body(),
    //   // bottomNavigationBar: CheckoutCard(),
    // );
  }

  // AppBar buildAppBar(BuildContext context) {
  //   return AppBar(
  //     title: Column(
  //       children: const [
  //         Text(
  //           "Satış Faturaları",
  //           style: TextStyle(color: Colors.black),
  //         ),
  //       ],
  //     ),
  //     actions: [
  //       IconButton(
  //         icon: const Icon(Icons.refresh),
  //         onPressed: getSatisFaturas,
  //       ),
  //     ],
  //   );
  // }
}
