import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stoktakip_app/api/pdf_api.dart';
import 'package:stoktakip_app/api/pdf_invoice_satisfatura_api.dart';
import 'package:stoktakip_app/functions/const_entities.dart';
import 'package:stoktakip_app/model/other/invoice.dart';
import 'package:stoktakip_app/model/satis_fatura/satis_fatura.dart';
import 'package:stoktakip_app/model/satis_fatura/satis_fatura_duzenle.dart';
import 'package:stoktakip_app/model/satis_fatura/urun_bilgileri.dart';
import 'package:stoktakip_app/screens/urun_bilgileri_duzenle/urun_bilgileri_duzenle_add.dart';
import 'package:stoktakip_app/services/api_services/satis_fatura_api_service.dart';
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
  List<SatisFatura> satisFaturaList = [];

  Future<List> getSatisFaturas() async {
    keyRefresh.currentState?.show();
    await Future.delayed(const Duration(milliseconds: 500));
    await SatisFaturaApiService.fetchSatisFatura().then((response) {
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
    await getSatisFaturas();
  }

  @override
  void initState() {
    getSatisFaturas();
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
              "Satış Faturaları",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: getSatisFaturas,
          ),
        ],
      ),
      body: buildList(),
    );
  }

  void actionPopUpItemSelected(String value,
      List<UrunBilgileri> urunBilgileriListesi, SatisFatura satisFatura) async {
    if (value == 'SatisRaporu') {
      // satisFaturaNew = satisFatura;
      final invoice = InvoiceSatisFatura(
          satisFatura: satisFatura,
          info: InvoiceInfo(
            description: 'Açıklama',
            number: '${DateTime.now().year}-9999',
          ),
          items: urunBilgileriListesi);

      final pdfFile = await PdfInvoiceSatisFaturaApi.generate(invoice);

      PdfApi.openFile(pdfFile);
      // You can navigate the user to edit page.
    } else if (value == 'Duzenle') {
      // await getSatisFaturas();
      satisFaturaDuzenle = SatisFaturaDuzenle(
          oncekiTutar: satisFatura.toplamTutar!,
          cariHesapAdi: satisFatura.firmaUnvani,
          cariHesapId: satisFatura.cariHesapId,
          satisFaturaId: satisFatura.id,
          satisFaturaKod: satisFatura.kod,
          satisFaturaAciklama: satisFatura.aciklama,
          satisFaturaOdemeTipi: satisFatura.odemeTipi,
          satisFaturaKdvSekli: satisFatura.kdvSekli,
          satisFaturaIskontoOrani: satisFatura.iskontoOrani,
          satisFaturaKdvOrani: satisFatura.faturaKdvOrani);
      urunBilgileriDeleteList = [];
      faturaDurum = true;
      Navigator.pushNamed(context, UrunBilgileriDuzenleAdd.routeName);
    } else {}
  }

  Widget buildList() => satisFaturaList.isEmpty
      ? const Center(child: CircularProgressIndicator())
      : RefreshWidget(
          keyRefresh: keyRefresh,
          onRefresh: getSatisFaturas,
          child: ListView.builder(
              shrinkWrap: true,
              primary: false,
              // padding: const EdgeInsets.all(16),
              itemCount: satisFaturaList.length,
              itemBuilder: (context, index) {
                return buildItem(context, index);
              }),
        );

  Widget buildItem(BuildContext context, int index) {
    // String firma = satisFaturaList[index].firmaUnvani!;

    Future<List> _getUrunBilgileri() async {
      await UrunBilgileriApiService.fetchUrunBilgileriBySatisFaturaId(
              satisFaturaList[index].id)
          .then(
        (response) {
          setState(() {
            dynamic list = json.decode(response.body);
            // List data = list['data'];
            List data = list;
            urunBilgileriGetIdList =
                data.map((model) => UrunBilgileri.fromJson(model)).toList();
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
            // await getSatisFaturas();

            await _getUrunBilgileri();
            actionPopUpItemSelected(
                value, urunBilgileriGetIdList, satisFaturaList[index]);
          },
        ),
      ),
    );
  }
}
