// ignore_for_file: avoid_print, unnecessary_null_comparison

import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:stoktakip_app/const/text_const.dart';
import 'package:stoktakip_app/functions/const_entities.dart';
import 'package:stoktakip_app/functions/will_pop_scope_back_function.dart';
import 'package:stoktakip_app/model/cari_hesap/cari_hesap.dart';
import 'package:stoktakip_app/screens/satis_fatura_list/list_screen_satis_fatura.dart';
import 'package:stoktakip_app/services/api_services/cari_hesap_api_service.dart';
import '../../size_config.dart';
import '../urun_bilgileri/urun_bilgileri_add.dart';

class FaturaOlustur extends StatefulWidget {
  static String routeName = "/faturaolustur";

  const FaturaOlustur({Key? key}) : super(key: key);
  @override
  _FaturaOlusturState createState() => _FaturaOlusturState();
}

class _FaturaOlusturState extends State<FaturaOlustur> {
  List<CariHesap> cariHesap = <CariHesap>[];
  List<String> _suggestions = <String>[];
  var cariHesap1 = <CariHesap>[];
  Object? dropDownMenu;
  String? _selectedItem;
  int? _selectedItemId;
  var searchController = TextEditingController();
  var aciklamaController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<List> _getCariHesaps() async {
    await CariHesapApiService.fetchCariHesap().then((response) {
      setState(() {
        dynamic list = json.decode(response.body);
        // List data = list['data'];
        List data = list;
        cariHesap = data.map((model) => CariHesap.fromJson(model)).toList();
        _suggestions =
            data.map((model) => CariHesap.fromJson(model).firma!).toList();
      });
    });
    return cariHesap;
  }

  Future getCariHesapById(int id) async {
    await CariHesapApiService.fetchCariHesapById(id).then((response) {
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
        bool? result = await onBackPressedCancelApp(context);
        result ??= false;
        return result;
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
                  // Text('data'),
                  // DropdownButton(
                  //   hint: const Text('Firma Se??iniz'),
                  //   value: dropDownMenu,
                  //   items: cariHesap.map((cari) {
                  //     return DropdownMenuItem(
                  //       value: cari.id,
                  //       child: Text(cari.firma.toString()),
                  //     );
                  //   }).toList(),
                  //   onChanged: (newValue) async {
                  //     setState(() {
                  //       dropDownMenu = newValue;
                  //       cariHesapSingle.id = int.parse(dropDownMenu.toString());
                  //       // await fetchCariHesapById(int.parse(dropDownMenu.toString()));
                  //     });
                  //     await getCariHesapById();
                  //   },
                  // ),

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
                          cariHesapSingle.id = cariHesap
                              .where((element) => element.firma == value)
                              .single
                              .id;
                          dropDownMenu = 1;
                        });
                        await getCariHesapById(cariHesapSingle.id!);
                        print(cariHesapSingle.id);
                      },
                      suggestions: _suggestions,
                    ),
                  ),

                  // Container(
                  //   width: double.infinity,
                  //   margin: const EdgeInsets.symmetric(horizontal: 20),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(30),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.grey.withOpacity(0.2),
                  //         blurRadius: 10,
                  //         offset: Offset(0, 10),
                  //       ),
                  //     ],
                  //   ),
                  //   child: DropdownSearch<String>(
                  //     //mode of dropdown
                  //     mode: Mode.BOTTOM_SHEET,
                  //     //to show search box
                  //     showSearchBox: true,
                  //     // showSelectedItem: true,
                  //     //list of dropdown items
                  //     showClearButton: true,
                  //     items: _suggestions,
                  //     label: "Firma Se??iniz..",
                  //     onChanged: (value) async {
                  //       if (value != null) {
                  //         setState(() {
                  //           _selectedItem = value;
                  //           cariHesapSingle.id = cariHesap
                  //               .where((element) => element.firma == value)
                  //               .single
                  //               .id;
                  //           dropDownMenu = 1;
                  //         });
                  //         await getCariHesapById(cariHesapSingle.id!);
                  //         print(cariHesapSingle.id);
                  //       } else {
                  //         _selectedItem = null;
                  //       }
                  //     },
                  //   ),
                  // ),

                  SizedBox(
                    // key: UniqueKey(),
                    height: 40,
                    // decoration: BoxDecorationSettings(),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.center,
                      width: double.infinity,
                      child: FocusScope(
                        onFocusChange: (value) =>
                            faturaAciklama = aciklamaController.text,
                        child: TextFormField(
                          controller: aciklamaController,
                          onEditingComplete: () {
                            faturaAciklama = aciklamaController.text;
                          },
                          decoration: const InputDecoration(
                            labelText: "A????klama Giriniz.",
                            icon: Icon(Icons.comment),
                          ),
                          style: kMetinStili,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    width: double.infinity,
                    height: getProportionateScreenHeight(90),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: ElevatedButton(
                          child: const Text("Sat???? Faturas??"),
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
                              Navigator.pushNamed(
                                  context, UrunBilgileriAdd.routeName);
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
                            primary: Colors.deepOrange,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          child: const Text("Sat??n Alma Faturas??"),
                          onPressed: () {
                            if (dropDownMenu == null) {
                            } else {
                              faturaDurum = false;
                              searchController.clear();
                              dropDownMenu = null;
                              aciklamaController.clear();

                              Navigator.pushNamed(
                                  context, UrunBilgileriAdd.routeName);
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
                          child: const Text("Sat???? Faturalar?? Listesi"),
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
                        'L??tfen Firma Se??iniz!',
                        style: TextStyle(fontSize: 16, color: Colors.redAccent),
                      )
                    : Column(
                        children: [
                          Text(
                            "Se??ili Firma: ${_selectedItem!}\nBakiye: ${cariHesapSingle.bakiye!.toStringAsFixed(2)}",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.w600),
                          ),

                          // SizedBox(
                          //   key: UniqueKey(),
                          //   height: 25,
                          //   // decoration: BoxDecorationSettings(),
                          //   child: Container(
                          //     alignment: Alignment.center,
                          //     width: getProportionateScreenWidth(300),
                          //     child: TextFormField(
                          //       controller: aciklamaController,
                          //       decoration: const InputDecoration(
                          //         labelText: "A????klama Giriniz.",
                          //         icon: Icon(Icons.comment),
                          //         hintText: "Say?? Giriniz.",
                          //       ),
                          //       style: kMetinStili,
                          //     ),
                          //   ),
                          // )
                        ],
                      ),

                // )
                // MaterialButton(
                //   onPressed: () {},
                //   color: Colors.black,
                //   minWidth: 50,
                //   height: 50,
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(50),
                //   ),
                //   padding: const EdgeInsets.all(0),
                //   child: const Icon(
                //     Icons.arrow_forward_ios,
                //     color: Colors.blueGrey,
                //     size: 24,
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
