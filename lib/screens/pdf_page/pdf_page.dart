import 'package:flutter/material.dart';
import 'package:stoktakip_app/api/pdf_api.dart';
import 'package:stoktakip_app/api/pdf_invoice_api.dart';
import 'package:stoktakip_app/functions/const_entities.dart';
import 'package:stoktakip_app/model/invoice.dart';
import 'package:stoktakip_app/model/urun_bilgileri.dart';
import 'package:stoktakip_app/widget/button_widget.dart';
import 'package:stoktakip_app/widget/title_widget.dart';

import '../../main.dart';

class PdfPage extends StatefulWidget {
  @override
  _PdfPageState createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          // title: Text(MyApp.title),
          title: const Text("PDF"),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.all(32),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const TitleWidget(
                  icon: Icons.picture_as_pdf,
                  text: 'Generate Invoice',
                ),
                const SizedBox(height: 48),
                ButtonWidget(
                  text: 'Fiş PDF',
                  onClicked: () async {
                    final date = DateTime.now();
                    final dueDate = date.add(Duration(days: 7));

                    final invoice = Invoice(
                        satisFatura: satisFaturaNew,
                        info: InvoiceInfo(
                          date: date,
                          dueDate: dueDate,
                          description: 'My description...',
                          number: '${DateTime.now().year}-9999',
                        ),
                        items: urunBilgileriList
                        // [
                        // InvoiceItem(
                        //   description: 'Coffee',
                        //   date: DateTime.now(),
                        //   quantity: 3,
                        //   vat: 0.19,
                        //   unitPrice: 5.99,
                        // ),
                        // InvoiceItem(
                        //   description: 'Water',
                        //   date: DateTime.now(),
                        //   quantity: 8,
                        //   vat: 0.19,
                        //   unitPrice: 0.99,
                        // ),
                        // InvoiceItem(
                        //   description: 'Orange',
                        //   date: DateTime.now(),
                        //   quantity: 3,
                        //   vat: 0.19,
                        //   unitPrice: 2.99,
                        // ),
                        // InvoiceItem(
                        //   description: 'Apple',
                        //   date: DateTime.now(),
                        //   quantity: 8,
                        //   vat: 0.19,
                        //   unitPrice: 3.99,
                        // ),
                        // InvoiceItem(
                        //   description: 'Mango',
                        //   date: DateTime.now(),
                        //   quantity: 1,
                        //   vat: 0.19,
                        //   unitPrice: 1.59,
                        // ),
                        // InvoiceItem(
                        //   description: 'Blue Berries',
                        //   date: DateTime.now(),
                        //   quantity: 5,
                        //   vat: 0.19,
                        //   unitPrice: 0.99,
                        // ),
                        // InvoiceItem(
                        //   description: 'Lemon',
                        //   date: DateTime.now(),
                        //   quantity: 4,
                        //   vat: 0.19,
                        //   unitPrice: 1.29,
                        // ),
                        // ],

                        );

                    final pdfFile = await PdfInvoiceApi.generate(invoice);

                    PdfApi.openFile(pdfFile);
                  },
                ),
              ],
            ),
          ),
        ),
      );
}
