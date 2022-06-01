import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stoktakip_app/api/pdf_api.dart';
import 'package:stoktakip_app/api/pdf_invoice_gelensiparis_api.dart';
import 'package:stoktakip_app/functions/const_entities.dart';
import 'package:stoktakip_app/model/verilen_siparis/verilen_siparis_bilgileri.dart';
import 'package:stoktakip_app/model/gelen_urun_siparis/gelen_siparis.dart';
import 'package:stoktakip_app/model/gelen_urun_siparis/gelen_siparis_bilgileri.dart';
import 'package:stoktakip_app/model/other/invoice.dart';
import 'package:stoktakip_app/model/satis_fatura/urun_bilgileri.dart';
import 'package:stoktakip_app/screens/gelen_urun_siparisi/gelen_siparis_bilgileri/gelen_siparis_bilgileri_add.dart';
import 'package:stoktakip_app/services/api_services/verilen_siparis_api_service.dart';
import 'package:stoktakip_app/services/api_services/gelen_siparis_api_service.dart';
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
  List<GelenSiparis> gelenSiparisList = [];

  Future<List> getGelenSiparisler() async {
    keyRefresh.currentState?.show();
    await Future.delayed(const Duration(milliseconds: 500));
    await GelenSiparisApiService.fetchGelenSiparis().then((response) {
      setState(() {
        dynamic list = json.decode(response.body);
        // List data = list['data'];
        List data = list;
        gelenSiparisList =
            data.map((model) => GelenSiparis.fromJson(model)).toList();
      });
    });
    return gelenSiparisList;
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
        }
      });
    });
  }

  Future getVerilenSiparisBilgileriByCariId(int id) async {
    await VerilenSiparisApiService.fetchVerilenSiparisBilgileriByCariIdControl(
            id)
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
    await getGelenSiparisler();
  }

  @override
  void initState() {
    getGelenSiparisler();
    // initStateAsync();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            onPressed: getGelenSiparisler,
          ),
        ],
      ),
      body: buildList(),
    );
  }

  void actionPopUpItemSelected(
      String value,
      List<GelenSiparisBilgileri> gelenSiparisBilgileri,
      GelenSiparis gelenSiparis) async {
    if (value == 'Rapor') {
      // satisFaturaNew = satisFatura;
      final invoice = InvoiceGelenSiparis(
          gelenSiparis: gelenSiparis,
          info: InvoiceInfo(
            description: 'Açıklama',
            number: '${DateTime.now().year}-9999',
          ),
          items: gelenSiparisBilgileri);

      final pdfFile = await PdfInvoiceGelenSiparisApi.generate(invoice);

      PdfApi.openFile(pdfFile);
      // You can navigate the user to edit page.
    } else if (value == 'Duzenle') {
      if (gelenSiparis.isSeciliSiparis!) {
        await getVerilenSiparisBilgileriById(gelenSiparis.verilenSiparisId!);
      } else if (!gelenSiparis.isSeciliSiparis!) {
        await getVerilenSiparisBilgileriByCariId(gelenSiparis.cariHesapId!);
      }

      gelenSiparisEdit = gelenSiparis;
      gelenSiparisBilgileriDeleteList = [];
      gelenSiparisDurum = false;
      Navigator.pushNamed(context, GelenSiparisBilgileriAdd.routeName);
    } else {}
  }

  Widget buildList() => gelenSiparisList.isEmpty
      ? const Center(child: CircularProgressIndicator())
      : RefreshWidget(
          keyRefresh: keyRefresh,
          onRefresh: getGelenSiparisler,
          child: ListView.builder(
              shrinkWrap: true,
              primary: false,
              // padding: const EdgeInsets.all(16),
              itemCount: gelenSiparisList.length,
              itemBuilder: (context, index) {
                return buildItem(context, index);
              }),
        );

  Widget buildItem(BuildContext context, int index) {
    // String firma = gelenSiparisList[index].siparisAdi!;

    Future<List> _getGelenSiparisBilgileri() async {
      print(gelenSiparisList[index].id);
      await GelenSiparisApiService.fetchGelenSiparisBilgileriByGelenSiparisId(
              gelenSiparisList[index].id)
          .then(
        (response) {
          setState(() {
            dynamic list = json.decode(response.body);
            // List data = list['data'];
            List data = list;
            gelenSiparisBilgileriGetIdList = data
                .map((model) => GelenSiparisBilgileri.fromJson(model))
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
          cart: gelenSiparisList[index],
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

            await _getGelenSiparisBilgileri();
            actionPopUpItemSelected(
                value, gelenSiparisBilgileriGetIdList, gelenSiparisList[index]);
          },
        ),
      ),
    );
  }
}
