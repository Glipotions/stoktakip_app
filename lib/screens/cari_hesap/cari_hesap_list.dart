// ignore_for_file: avoid_print, unnecessary_null_comparison

import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:stoktakip_app/model/cari_hesap.dart';
import 'package:stoktakip_app/services/api.services.dart';

import '../../size_config.dart';
import '../urun_bilgileri/urun_bilgileri_add.dart';

class CariHesapList extends StatefulWidget {
  static String routeName = "/carihesaplist";
  @override
  _CariHesapListState createState() => _CariHesapListState();
}

class _CariHesapListState extends State<CariHesapList> {
  List<CariHesap> cariHesap = <CariHesap>[];
  var cariHesap1 = <CariHesap>[];
  Object? dropDownMenu;

  Future<List> _getCariHesaps() async {
    await APIServices.fetchCariHesap().then((response) {
      setState(() {
        dynamic list = json.decode(response.body);
        // List data = list['data'];
        List data = list;
        cariHesap = data.map((model) => CariHesap.fromJson(model)).toList();
      });
    });
    return cariHesap;
  }

  Future getCariHesapById() async {
    await APIServices.fetchCariHesapById(cariHesapSingle.id!).then((response) {
      setState(() {
        dynamic list = json.decode(response.body);
        List data = list;
        // List data = list['data'];
        cariHesap1 = data
            .map((model) => CariHesap.fromJson(model))
            .cast<CariHesap>()
            .toList();
        for (var element in cariHesap1) {
          cariHesapSingle.iskontoOrani = element.iskontoOrani!;
          cariHesapSingle.bakiye = element.bakiye;
          cariHesapSingle.firma = element.firma;
        }
        print(cariHesapSingle.bakiye);
        print(cariHesapSingle.iskontoOrani);
      });
    });
  }

  Future<void> initStateAsync() async {
    await _getCariHesaps();
  }

  @override
  void initState() {
    initStateAsync();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        floatingActionButton: _buidFloatingButton(),
        appBar: AppBar(
          title: const Text("Stok App"),
        ),
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text('data'),
                DropdownButton(
                  hint: Text('Firma Seçiniz'),
                  value: dropDownMenu,
                  items: cariHesap.map((cari) {
                    return DropdownMenuItem(
                      value: cari.id,
                      child: Text(cari.firma.toString()),
                    );
                  }).toList(),
                  onChanged: (newValue) async {
                    setState(() {
                      dropDownMenu = newValue;
                      cariHesapSingle.id = int.parse(dropDownMenu.toString());
                      // await fetchCariHesapById(int.parse(dropDownMenu.toString()));
                    });
                    await getCariHesapById();
                  },
                ),
                // DropdownSearch<String>(
                //     mode: Mode.MENU,
                //     onFind: ,
                //     label: 'Firma Seç',
                //     hint: "Firma Seç",
                //     popupItemDisabled: (String s) => s.startsWith('I'),
                //     onChanged: (newValue) {
                //     setState(() async {
                //       dropDownMenu = newValue;
                //       cariHesapSingle.id = int.parse(dropDownMenu.toString());
                //       // await fetchCariHesapById(int.parse(dropDownMenu.toString()));
                //       await getCariHesapById();
                //     });
                //   },
                //     selectedItem: "Brazil"),
              ],
            ),
          ),
        ));
  }

  Widget _buidFloatingButton() {
    return FloatingActionButton(
      child: const Icon(Icons.person_add),
      onPressed: () {
        if (dropDownMenu == null) {
        } else {
          Navigator.pushNamed(context, UrunBilgileriAdd.routeName);
        }
      },
    );
  }
}
