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
  Future<List> _getSatisFaturas() async {
    await APIServices.fetchSatisFatura().then((response) {
      setState(() {
        dynamic list = json.decode(response.body);
        // List data = list['data'];
        List data = list;
        satisFaturaList =
            data.map((model) => SatisFatura.fromJson(model)).toList();
      });
    });
    return satisFaturaList;
  }

  Future<void> initStateAsync() async {
    await _getSatisFaturas();
  }

  @override
  void initState() {
    initStateAsync();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: const Body(),
      // bottomNavigationBar: CheckoutCard(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Column(
        children: const [
          Text(
            "Satış Faturaları",
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.pushNamed(context, SettingsPage.routeName);
          },
        ),
      ],
    );
  }
}
