// ignore_for_file: avoid_print, unnecessary_null_comparison

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:stoktakip_app/functions/const_functions.dart';
import 'package:stoktakip_app/model/cari_hesap.dart';
import 'package:stoktakip_app/services/api.services.dart';
import '../../size_config.dart';
import '../urun_bilgileri/urun_bilgileri_add.dart';

class FaturaOlustur extends StatefulWidget {
  static String routeName = "/carihesaplist";

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

  Future<List> _getCariHesaps() async {
    await APIServices.fetchCariHesap().then((response) {
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
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      // floatingActionButton: _buidFloatingButton(),
      appBar: AppBar(
        title: const Text("Glipotions Stok Takip"),
      ),
      body: Container(
        margin: const EdgeInsets.all(2),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Text('data'),
              // DropdownButton(
              //   hint: const Text('Firma Seçiniz'),
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
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: SearchField(
                  hint: 'Ara',
                  controller: searchController,
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
                    await getCariHesapById();
                    print(cariHesapSingle.id);
                  },
                  suggestions: _suggestions,
                ),
              ),

              // DropdownSearch<DropdownMenuItem<int>>(
              //   mode: Mode.MENU,
              //   items: cariHesap.map((cari) {
              //     return DropdownMenuItem(
              //       value: cari.id,
              //       child: Text(cari.firma.toString()),
              //     );
              //   }).toList(),
              //   label: "Firma Seçiniz.",
              //   onChanged: (newValue) async {
              //     setState(() {
              //       dropDownMenu = newValue;
              //       cariHesapSingle.id = int.parse(dropDownMenu.toString());
              //       // await fetchCariHesapById(int.parse(dropDownMenu.toString()));
              //     });
              //     await getCariHesapById();
              //     print(cariHesapSingle.id);
              //   },
              // ),

              SizedBox(
                width: double.infinity,
                height: getProportionateScreenHeight(90),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: ElevatedButton(
                      child: const Text("Satış Faturası"),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.brown,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: () {
                        if (searchController.text.isEmpty) {
                        } else {
                          faturaDurum = true;
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
                      child: const Text("Satın Alma Faturası"),
                      onPressed: () {
                        if (dropDownMenu == null) {
                        } else {
                          faturaDurum = false;
                          Navigator.pushNamed(
                              context, UrunBilgileriAdd.routeName);
                        }
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 90,
        padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _selectedItem == null
                ? const Text(
                    'Lütfen Firma Seçiniz!',
                    style: TextStyle(fontSize: 16, color: Colors.redAccent),
                  )
                : Text(
                    "Seçili Firma: ${_selectedItem!}\nBakiye: ${cariHesapSingle.bakiye!.toStringAsFixed(2)}",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w600)),
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
    );
  }

  // Widget _buidFloatingButton() {
  //   return FloatingActionButton(
  //     child: const Icon(Icons.add_chart),
  //     onPressed: () {
  //       if (dropDownMenu == null) {
  //       } else {
  //         Navigator.pushNamed(context, UrunBilgileriAdd.routeName);
  //       }
  //     },
  //   );
  // }
}
