import 'package:flutter/material.dart';
import 'package:stoktakip_app/functions/const_entities.dart';
import 'package:stoktakip_app/model/alinan_siparis/alinan_siparis_bilgileri.dart';
import 'package:stoktakip_app/widget/refresh_widget.dart';

// import 'list_card.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  // final UrunBilgileri satisFaturaList;
  // const Body(this._urunBilgileri);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final keyRefresh = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: const [
            Text(
              "Seçilen Sipariş Bilgileri",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.refresh),
        //     onPressed: getHazirlananSiparisler,
        //   ),
        // ],
      ),
      body: buildList(),
    );
  }

  Widget buildList() => alinanSiparisBilgileriList.isEmpty
      ? const Center(child: CircularProgressIndicator())
      : SingleChildScrollView(
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Kod')),
              DataColumn(label: Text('Miktar')),
              DataColumn(label: Text('Kalan Miktar')),
              // DataColumn(label: Text('Kod')),
            ],
            rows: getRows(alinanSiparisBilgileriList),
          ),
        );

  List<DataRow> getRows(List<AlinanSiparisBilgileri> alinanSiparisBilgileri) =>
      alinanSiparisBilgileri.map((AlinanSiparisBilgileri alinanSiparisBilgisi) {
        final cells = [
          alinanSiparisBilgisi.urunKodu,
          alinanSiparisBilgisi.miktar,
          alinanSiparisBilgisi.kalanMiktar
        ];

        return DataRow(cells: getCells(cells));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();
}
