import 'package:flutter/material.dart';
import 'package:stoktakip_app/functions/const_entities.dart';
import 'package:stoktakip_app/model/alinan_siparis/alinan_siparis_bilgileri.dart';
import 'package:stoktakip_app/widget/search_widget.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final keyRefresh = GlobalKey<RefreshIndicatorState>();
  String query = '';
  List<AlinanSiparisBilgileri> cart = alinanSiparisBilgileriList;

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
      ),
      body: buildList(),
    );
  }

  Widget buildList() => SingleChildScrollView(
        child: Column(
          children: [
            buildSearch(),
            alinanSiparisBilgileriList.isEmpty
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
                  ),
          ],
        ),
      );

  List<DataRow> getRows(List<AlinanSiparisBilgileri> alinanSiparisBilgileri) =>
      cart.map((AlinanSiparisBilgileri alinanSiparisBilgisi) {
        final cells = [
          alinanSiparisBilgisi.urunKodu,
          alinanSiparisBilgisi.miktar,
          alinanSiparisBilgisi.kalanAdet
        ];

        return DataRow(cells: getCells(cells));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Ürün Kodu veya Ürün Adı',
        onChanged: searchProduct,
      );
  void searchProduct(String query) {
    final products = alinanSiparisBilgileriList.where((urun) {
      final urunLower = urun.urunKodu!.toLowerCase();
      final urunAdiLower = urun.urunAdi!.toLowerCase();
      final searchLower = query.toLowerCase();

      return urunLower.contains(searchLower) ||
          urunAdiLower.contains(searchLower);
    }).toList();

    setState(() {
      this.query = query;
      cart = products;
    });
  }
}
