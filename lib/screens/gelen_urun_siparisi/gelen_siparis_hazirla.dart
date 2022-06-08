// ignore_for_file: avoid_print, unnecessary_null_comparison

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:stoktakip_app/functions/const_entities.dart';
import 'package:stoktakip_app/model/gelen_urun_siparis/gelen_siparis.dart';
import 'package:stoktakip_app/model/verilen_siparis/verilen_siparis.dart';
import 'package:stoktakip_app/model/verilen_siparis/verilen_siparis_bilgileri.dart';
import 'package:stoktakip_app/screens/gelen_urun_siparisi/siparisi_goruntule/gelen_siparisi_goruntule_list.dart';
import 'package:stoktakip_app/services/api_services/verilen_siparis_api_service.dart';
import '../../size_config.dart';
import 'gelen_siparis_bilgileri/gelen_siparis_bilgileri_add.dart';
import 'gelen_siparis_list/list_screen_gelen_siparis.dart';

class GelenSiparisHazirla extends StatefulWidget {
  static String routeName = "/gelen-siparis-hazirla";

  const GelenSiparisHazirla({Key? key}) : super(key: key);
  @override
  _GelenSiparisHazirlaState createState() => _GelenSiparisHazirlaState();
}

class _GelenSiparisHazirlaState extends State<GelenSiparisHazirla> {
  List<VerilenSiparis> verilenSiparisler = [];
  // List<VerilenSiparisBilgileri> verilenSiparisBilgileri = [];

  Object? dropDownMenu;
  String? _selectedItem;
  // int? _selectedItemId;
  var searchController = TextEditingController();
  var aciklamaController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isSwitched = false;
  final keyRefresh = GlobalKey<RefreshIndicatorState>();

  Future<List> _getVerilenSiparisler() async {
    await VerilenSiparisApiService.fetchVerilenSiparis().then((response) {
      setState(() {
        dynamic list = json.decode(response.body);
        // List data = list['data'];
        List data = list;
        verilenSiparisler = data
            .map((model) => VerilenSiparis.fromJson(model))
            .where((element) => element.durum == true)
            .toList();
        // _suggestions = verilenSiparisler.map((e) => e.siparisTanimi!).toList();
      });
    });
    return verilenSiparisler;
  }

  Future getVerilenSiparisBilgileriById(int id) async {
    await VerilenSiparisApiService.fetchVerilenSiparisBilgileriById(id)
        .then((response) {
      setState(() {
        if (response.body.isNotEmpty) {
          dynamic list = json.decode(response.body);
          List data = list;
          // List data = list['data'];
          verilenSiparisBilgileriList = data
              .map((model) => VerilenSiparisBilgileri.fromJson(model))
              .cast<VerilenSiparisBilgileri>()
              .toList();
          verilenSiparisBilgileriControlString = response.body;
        }
      });
    });
  }

  Future getVerilenSiparisBilgileriByCariId(int id) async {
    await VerilenSiparisApiService.fetchVerilenSiparisBilgileriByCariId(id)
        .then((response) {
      setState(() {
        if (response.body.isNotEmpty) {
          dynamic list = json.decode(response.body);
          List data = list;
          // List data = list['data'];
          verilenSiparisBilgileriList = data
              .map((model) => VerilenSiparisBilgileri.fromJson(model))
              .cast<VerilenSiparisBilgileri>()
              .toList();
        }
      });
    });
  }

  Future<void> initStateAsync() async {
    await _getVerilenSiparisler();
    if (gelenSiparisBilgileriList.isNotEmpty ||
        gelenSiparisBilgileriGetIdList.isNotEmpty) {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                'TAMAMLANMAMIŞ SİPARİŞİNİZ VAR!',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.orange),
              ),
              content: const Text(
                'TAMAMLANMAYAN SİPARİŞİNİZE DEVAM ETMEK İSTİYORMUSUNUZ!',
                style: TextStyle(color: Colors.black),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'HAYIR');
                  },
                  child: const Text('HAYIR'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'EVET');
                    Navigator.pushNamed(
                        context, GelenSiparisBilgileriAdd.routeName);
                    gelenSiparisDurum =
                        gelenSiparisBilgileriList.isNotEmpty ? true : false;
                  },
                  child: const Text('EVET'),
                ),
              ],
            );
          });
    }
  }

  @override
  void initState() {
    formKey;

    initStateAsync();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    aciklamaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context, rootNavigator: true).pop();
        return true;
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: Container(
            margin: const EdgeInsets.all(2),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),
                  SizedBox(
                    // height: getProportionateScreenHeight(10),
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.yellow[300],
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Spacer(
                            flex: 1,
                          ),
                          Expanded(
                            flex: 8,
                            child: Text(
                              isSwitched == true
                                  ? "CARİNİN TÜM VERİLEN SİPARİŞLERİ"
                                  : "SEÇİLİ VERİLEN SİPARİŞ",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade800,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Switch(
                              value: isSwitched,
                              onChanged: (value) async {
                                setState(() {
                                  isSwitched = value;
                                });
                                verilenSiparisBilgileriList.clear();

                                if (isSwitched && searchController != null) {
                                  await getVerilenSiparisBilgileriByCariId(
                                      verilenSiparisSingle.cariHesapId!);
                                } else if (!isSwitched &&
                                    searchController != null) {
                                  await getVerilenSiparisBilgileriById(
                                      verilenSiparisSingle.id!);
                                }
                                if (verilenSiparisBilgileriList.isEmpty) {
                                  const Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                              activeTrackColor: Colors.lightGreenAccent,
                              activeColor: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: SearchField(
                      hint: 'Ara',
                      controller: searchController,
                      suggestionState: Suggestion.expand,
                      searchInputDecoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blueGrey.shade200,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Colors.blue.withOpacity(0.8),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      maxSuggestionsInViewPort: 6,
                      itemHeight: 50,
                      suggestionsDecoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onSuggestionTap: (value) async {
                        setState(() {
                          _selectedItem = value.item.toString();
                          var verilenSiparisEntity = verilenSiparisler
                              .where((element) =>
                                  element.siparisTanimi == value.searchKey)
                              .single;
                          verilenSiparisSingle.id = verilenSiparisEntity.id;
                          verilenSiparisSingle.cariHesapId =
                              verilenSiparisEntity.cariHesapId;
                          verilenSiparisSingle.siparisTanimi =
                              value.item.toString();
                          verilenSiparisSingle.aciklama =
                              verilenSiparisEntity.aciklama;

                          gelenSiparisSingle = GelenSiparis(
                            aciklama: verilenSiparisEntity.aciklama,
                            verilenSiparisId: verilenSiparisEntity.id,
                            siparisAdi: verilenSiparisEntity.siparisTanimi,
                            durum: true,
                            isSeciliSiparis: !isSwitched,
                          );

                          dropDownMenu = 1;
                        });
                        verilenSiparisBilgileriList.clear();
                        gelenSiparisBilgileriList.clear();
                        gelenSiparisBilgileriGetIdList.clear();
                        if (isSwitched && searchController != null) {
                          await getVerilenSiparisBilgileriByCariId(
                              verilenSiparisSingle.cariHesapId!);
                        } else if (!isSwitched && searchController != null) {
                          await getVerilenSiparisBilgileriById(
                              verilenSiparisSingle.id!);
                        }
                        if (verilenSiparisBilgileriList.isEmpty) {
                          const Center(child: CircularProgressIndicator());
                        }
                      },
                      // suggestions: _suggestions,
                      suggestions: verilenSiparisler
                          .map((e) =>
                              SearchFieldListItem(e.siparisTanimi!, item: e))
                          .toList(),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: getProportionateScreenHeight(90),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: ElevatedButton(
                          child: const Text("Gelen Siparişi Gir"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.brown,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          onPressed: () {
                            //searchController.text.isEmpty
                            if (dropDownMenu == null) {
                            } else {
                              gelenSiparisDurum = true;
                              searchController.clear();
                              // aciklamaController.clear();
                              dropDownMenu = null;
                              Navigator.pushNamed(
                                  context, GelenSiparisBilgileriAdd.routeName);
                            }
                          }),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: getProportionateScreenHeight(90),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.lightBlue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          child: const Text("Seçilen Siparişi Gör"),
                          onPressed: () {
                            if (dropDownMenu == null) {
                            } else {
                              Navigator.pushNamed(context,
                                  ListGelenSiparisiGoruntuleTable.routeName);
                            }
                          }),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: getProportionateScreenHeight(90),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.cyan,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          child: const Text("Gelen Siparişler Listesi"),
                          onPressed: () {
                            aciklamaController.clear();
                            Navigator.pushNamed(
                                context, ListScreenGelenSiparis.routeName);
                          }),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            height: getProportionateScreenHeight(70),
            padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _selectedItem == null
                    ? const Text(
                        'Lütfen Hazırlanacak Siparişi Seçiniz!',
                        style: TextStyle(fontSize: 16, color: Colors.redAccent),
                      )
                    : Column(
                        children: [
                          Text(
                            "Seçili Sipariş: \n${_selectedItem!}",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
