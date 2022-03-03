// ignore_for_file: avoid_print, unnecessary_null_comparison

import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:stoktakip_app/const/text_const.dart';
import 'package:stoktakip_app/functions/const_entities.dart';
import 'package:stoktakip_app/functions/will_pop_scope_back_function.dart';
import 'package:stoktakip_app/model/alinan_siparis/alinan_siparis.dart';
import 'package:stoktakip_app/model/alinan_siparis/alinan_siparis_bilgileri.dart';
import 'package:stoktakip_app/model/cari_hesap/cari_hesap.dart';
import 'package:stoktakip_app/screens/satis_fatura_list/list_screen_satis_fatura.dart';
import 'package:stoktakip_app/screens/siparis_hazirla/hazirlanan_siparis_bilgileri/hazirlanan_siparis_bilgileri_add.dart';
import 'package:stoktakip_app/services/api_services/alinan_siparis_api_service.dart';
import 'package:stoktakip_app/services/api_services/cari_hesap_api_service.dart';
import '../../size_config.dart';
import '../urun_bilgileri/urun_bilgileri_add.dart';

class SiparisHazirla extends StatefulWidget {
  static String routeName = "/siparis";

  const SiparisHazirla({Key? key}) : super(key: key);
  @override
  _SiparisHazirlaState createState() => _SiparisHazirlaState();
}

class _SiparisHazirlaState extends State<SiparisHazirla> {
  List<AlinanSiparis> alinanSiparisler = [];
  // List<AlinanSiparisBilgileri> alinanSiparisBilgileri = [];
  List<String> _suggestions = <String>[];

  Object? dropDownMenu;
  String? _selectedItem;
  int? _selectedItemId;
  var searchController = TextEditingController();
  var aciklamaController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<List> _getAlinanSiparisler() async {
    await AlinanSiparisApiService.fetchAlinanSiparis().then((response) {
      setState(() {
        dynamic list = json.decode(response.body);
        // List data = list['data'];
        List data = list;
        alinanSiparisler =
            data.map((model) => AlinanSiparis.fromJson(model)).toList();
        _suggestions = data
            .map((model) => AlinanSiparis.fromJson(model).siparisTanimi!)
            .toList();
      });
    });
    return alinanSiparisler;
  }

  Future getAlinanSiparisBilgileriById(int id) async {
    await AlinanSiparisApiService.fetchAlinanSiparisBilgileriById(id)
        .then((response) {
      setState(() {
        if (response.body.isNotEmpty) {
          dynamic list = json.decode(response.body);
          List data = list;
          // List data = list['data'];
          alinanSiparisBilgileriList = data
              .map((model) => AlinanSiparisBilgileri.fromJson(model))
              .cast<AlinanSiparisBilgileri>()
              .toList();
        }
      });
    });
  }

  Future<void> initStateAsync() async {
    await _getAlinanSiparisler();
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
        // bool? result = await onBackPressedCancelApp(context);
        // result ??= false;
        // return result;
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
                      suggestionState: SuggestionState.enabled,
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
                      onTap: (value) async {
                        setState(() {
                          _selectedItem = value!;
                          alinanSiparisSingle.id = alinanSiparisler
                              .where(
                                  (element) => element.siparisTanimi == value)
                              .single
                              .id;
                          dropDownMenu = 1;
                        });
                        print(alinanSiparisSingle.id);
                        await getAlinanSiparisBilgileriById(
                            alinanSiparisSingle.id!);
                        print(alinanSiparisBilgileriList.length);
                      },
                      suggestions: _suggestions,
                    ),
                  ),
                  // SizedBox(
                  //   // key: UniqueKey(),
                  //   height: 40,
                  //   // decoration: BoxDecorationSettings(),
                  //   child: Container(
                  //     margin: const EdgeInsets.symmetric(horizontal: 20),
                  //     alignment: Alignment.center,
                  //     width: double.infinity,
                  //     child: FocusScope(
                  //       onFocusChange: (value) =>
                  //           faturaAciklama = aciklamaController.text,
                  //       child: TextFormField(
                  //         controller: aciklamaController,
                  //         onEditingComplete: () {
                  //           faturaAciklama = aciklamaController.text;
                  //         },
                  //         decoration: const InputDecoration(
                  //           labelText: "Açıklama Giriniz.",
                  //           icon: Icon(Icons.comment),
                  //         ),
                  //         style: kMetinStili,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    width: double.infinity,
                    height: getProportionateScreenHeight(90),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: ElevatedButton(
                          child: const Text("Sipariş Hazırla"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.brown,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          onPressed: () {
                            //searchController.text.isEmpty
                            if (dropDownMenu == null) {
                            } else {
                              faturaDurum = true;
                              searchController.clear();
                              aciklamaController.clear();
                              dropDownMenu = null;
                              Navigator.pushNamed(context,
                                  HazirlananSiparisBilgileriAdd.routeName);
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
                          child: const Text("Satış Faturaları Listesi"),
                          onPressed: () {
                            aciklamaController.clear();
                            Navigator.pushNamed(
                                context, ListScreenSatisFatura.routeName);
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
                            "Seçili Sipariş: ${_selectedItem!}}",
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
