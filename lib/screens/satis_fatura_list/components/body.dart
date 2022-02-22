import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stoktakip_app/api/pdf_api.dart';
import 'package:stoktakip_app/api/pdf_invoice_api.dart';
import 'package:stoktakip_app/functions/const_entities.dart';
import 'package:stoktakip_app/model/invoice.dart';
import 'package:stoktakip_app/model/satis_fatura.dart';
import 'package:stoktakip_app/model/satis_fatura_duzenle.dart';
import 'package:stoktakip_app/model/urun_bilgileri.dart';
import 'package:stoktakip_app/screens/cart_satis_fatura_duzenle/cart_screen.dart';
import 'package:stoktakip_app/screens/urun_bilgileri_duzenle/urun_bilgileri_duzenle_add.dart';
import 'package:stoktakip_app/services/api.services.dart';
import 'package:stoktakip_app/size_config.dart';

import 'list_card.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  // final UrunBilgileri satisFaturaList;
  // const Body(this._urunBilgileri);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
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
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView.builder(
            itemCount: satisFaturaList.length,
            itemBuilder: (context, index) {
              String firma = satisFaturaList[index].firmaUnvani!;

              Future<List> _getUrunBilgileri() async {
                print(satisFaturaList[index].id);
                await APIServices.fetchUrunBilgileriBySatisFaturaId(
                        satisFaturaList[index].id)
                    .then((response) {
                  setState(() {
                    dynamic list = json.decode(response.body);
                    // List data = list['data'];
                    List data = list;
                    urunBilgileriGetIdList = data
                        .map((model) => UrunBilgileri.fromJson(model))
                        .toList();
                  });
                });
                return urunBilgileriGetIdList;
              }

              return Padding(
                key: UniqueKey(),
                padding: EdgeInsets.symmetric(
                    vertical: getProportionateScreenWidth(10)),
                child: ListTile(
                    leading: ListCard(
                      cart: satisFaturaList[index],
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem(
                            value: 'SatisRaporu',
                            child: Text("Satış Raporu"),
                          ),
                          const PopupMenuItem(
                            value: 'Duzenle',
                            child: Text("Düzenle"),
                          ),
                        ];
                      },
                      onSelected: (String value) async {
                        await _getUrunBilgileri();
                        actionPopUpItemSelected(value, urunBilgileriGetIdList,
                            satisFaturaList[index]);
                      },
                    )),
                // child: ListCard(
                //   cart: satisFaturaList[index],

                // child: Dismissible(
                //   key: Key(satisFaturaList[index].id.toString()),
                //   direction: DismissDirection.endToStart,
                //   onDismissed: (direction) {
                //     setState(() {
                //       satisFaturaList.removeAt(index);
                //       (context as Element).reassemble();
                //     });
                //   },
                //   background: Container(
                //     padding: const EdgeInsets.symmetric(horizontal: 20),
                //     decoration: BoxDecoration(
                //       color: const Color(0xFFFFE6E6),
                //       borderRadius: BorderRadius.circular(15),
                //     ),
                //     child: Row(
                //       children: const [
                //         Spacer(),
                //         Icon(Icons.restore_from_trash),
                //         // SvgPicture.asset("assets/icons/Trash.svg"),
                //       ],
                //     ),
                //   ),
                //   child: ListCard(
                //     cart: satisFaturaList[index],
                //   ),
                // ),
              );
            }));
  }

  void actionPopUpItemSelected(String value,
      List<UrunBilgileri> urunBilgileriListesi, SatisFatura satisFatura) async {
    if (value == 'SatisRaporu') {
      // satisFaturaNew = satisFatura;
      final invoice = Invoice(
          satisFatura: satisFatura,
          info: InvoiceInfo(
            description: 'Açıklama',
            number: '${DateTime.now().year}-9999',
          ),
          items: urunBilgileriListesi);

      final pdfFile = await PdfInvoiceApi.generate(invoice);

      PdfApi.openFile(pdfFile);
      // You can navigate the user to edit page.
    } else if (value == 'Duzenle') {
      satisFaturaDuzenle = SatisFaturaDuzenle(
          oncekiTutar: satisFatura.toplamTutar!,
          cariHesapAdi: satisFatura.firmaUnvani,
          cariHesapId: satisFatura.cariHesapId,
          satisFaturaId: satisFatura.id);
      print("${satisFaturaDuzenle.oncekiTutar}");
      faturaDurum = true;
      Navigator.pushNamed(context, UrunBilgileriDuzenleAdd.routeName);
    } else {}
  }
}
