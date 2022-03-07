import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stoktakip_app/api/pdf_api.dart';
import 'package:stoktakip_app/api/pdf_invoice_hazirlanansiparis_api.dart';
import 'package:stoktakip_app/functions/const_entities.dart';
import 'package:stoktakip_app/model/alinan_siparis/alinan_siparis_bilgileri.dart';
import 'package:stoktakip_app/model/hazirlanan_siparis/hazirlanan_siparis.dart';
import 'package:stoktakip_app/model/hazirlanan_siparis/hazirlanan_siparis_bilgileri.dart';
import 'package:stoktakip_app/model/other/invoice.dart';
import 'package:stoktakip_app/model/satis_fatura/urun_bilgileri.dart';
import 'package:stoktakip_app/screens/siparis_hazirla/hazirlanan_siparis_bilgileri/hazirlanan_siparis_bilgileri_add.dart';
import 'package:stoktakip_app/screens/urun_bilgileri_duzenle/urun_bilgileri_duzenle_add.dart';
import 'package:stoktakip_app/services/api_services/alinan_siparis_api_service.dart';
import 'package:stoktakip_app/services/api_services/hazirlanan_siparis_api_service.dart';
import 'package:stoktakip_app/services/api_services/urun_bilgileri_api_service.dart';
import 'package:stoktakip_app/size_config.dart';
import 'package:stoktakip_app/widget/refresh_widget.dart';

import 'list_card.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  // final UrunBilgileri satisFaturaList;
  // const Body(this._urunBilgileri);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final keyRefresh = GlobalKey<RefreshIndicatorState>();
  List<HazirlananSiparis> hazirlananSiparisList = [];

  Future<List> getHazirlananSiparisler() async {
    keyRefresh.currentState?.show();
    await Future.delayed(const Duration(milliseconds: 500));
    await HazirlananSiparisApiService.fetchHazirlananSiparis().then((response) {
      setState(() {
        dynamic list = json.decode(response.body);
        // List data = list['data'];
        List data = list;
        hazirlananSiparisList =
            data.map((model) => HazirlananSiparis.fromJson(model)).toList();
      });
    });
    return hazirlananSiparisList;
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
    await getHazirlananSiparisler();
  }

  @override
  void initState() {
    getHazirlananSiparisler();
    // initStateAsync();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 20),
    //   child: buildList(),
    // );
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: const [
            Text(
              "Hazırlanan Siparişler",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: getHazirlananSiparisler,
          ),
        ],
      ),
      body: buildList(),
    );
  }

  void actionPopUpItemSelected(
      String value,
      List<HazirlananSiparisBilgileri> hazirlananSiparisBilgileri,
      HazirlananSiparis hazirlananSiparis) async {
    if (value == 'Rapor') {
      // satisFaturaNew = satisFatura;
      final invoice = InvoiceHazirlananSiparis(
          hazirlananSiparis: hazirlananSiparis,
          info: InvoiceInfo(
            description: 'Açıklama',
            number: '${DateTime.now().year}-9999',
          ),
          items: hazirlananSiparisBilgileri);

      final pdfFile = await PdfInvoiceHazirlananSiparisApi.generate(invoice);

      PdfApi.openFile(pdfFile);
      // You can navigate the user to edit page.
    } else if (value == 'Duzenle') {
      await getAlinanSiparisBilgileriById(hazirlananSiparis.alinanSiparisId!);
      hazirlananSiparisEdit = hazirlananSiparis;
      hazirlananSiparisBilgileriDeleteList = [];
      hazirlananSiparisDurum = false;
      Navigator.pushNamed(context, HazirlananSiparisBilgileriAdd.routeName);
    } else {}
  }

  Widget buildList() => hazirlananSiparisList.isEmpty
      ? const Center(child: CircularProgressIndicator())
      : RefreshWidget(
          keyRefresh: keyRefresh,
          onRefresh: getHazirlananSiparisler,
          child: ListView.builder(
              shrinkWrap: true,
              primary: false,
              // padding: const EdgeInsets.all(16),
              itemCount: hazirlananSiparisList.length,
              itemBuilder: (context, index) {
                return buildItem(context, index);
              }),
        );

  Widget buildItem(BuildContext context, int index) {
    String firma = hazirlananSiparisList[index].siparisAdi!;

    Future<List> _getHazirlananSiparisBilgileri() async {
      print(hazirlananSiparisList[index].id);
      await HazirlananSiparisApiService
              .fetchHazirlananSiparisBilgileriByHazirlananSiparisId(
                  hazirlananSiparisList[index].id)
          .then(
        (response) {
          setState(() {
            dynamic list = json.decode(response.body);
            // List data = list['data'];
            List data = list;
            hazirlananSiparisBilgileriGetIdList = data
                .map((model) => HazirlananSiparisBilgileri.fromJson(model))
                .toList();
          });
        },
      );
      return urunBilgileriGetIdList;
    }

    return Padding(
      key: UniqueKey(),
      padding: EdgeInsets.symmetric(vertical: getProportionateScreenWidth(10)),
      child: ListTile(
        leading: ListCard(
          cart: hazirlananSiparisList[index],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) {
            return [
              const PopupMenuItem(
                value: 'Rapor',
                child: Text("Rapor"),
              ),
              const PopupMenuItem(
                value: 'Duzenle',
                child: Text("Düzenle"),
              ),
            ];
          },
          onSelected: (String value) async {
            // await getSatisFaturas();

            await _getHazirlananSiparisBilgileri();
            actionPopUpItemSelected(value, hazirlananSiparisBilgileriGetIdList,
                hazirlananSiparisList[index]);
          },
        ),
      ),
    );
  }
}
