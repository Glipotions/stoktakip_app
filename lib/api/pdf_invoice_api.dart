import 'dart:io';
// import 'package:generate_pdf_invoice_example/api/pdf_api.dart';
// import 'package:generate_pdf_invoice_example/model/customer.dart';
// import 'package:generate_pdf_invoice_example/model/invoice.dart';
// import 'package:generate_pdf_invoice_example/model/supplier.dart';
// import 'package:generate_pdf_invoice_example/utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:stoktakip_app/api/pdf_api.dart';
import 'package:stoktakip_app/model/cari_hesap.dart';
import 'package:stoktakip_app/model/customer.dart';
import 'package:stoktakip_app/model/invoice.dart';
import 'package:stoktakip_app/model/satis_fatura.dart';
import 'package:stoktakip_app/model/supplier.dart';
import 'package:stoktakip_app/model/urun_bilgileri.dart';

import '../utils.dart';

class PdfInvoiceApi {
  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(invoice),
        SizedBox(height: 3 * PdfPageFormat.cm),
        buildTitle(invoice),
        buildInvoice(invoice),
        Divider(),
        buildTotal(invoice),
      ],
      // footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static Widget buildHeader(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     buildSupplierAddress(invoice.supplier),
          //     Container(
          //       height: 50,
          //       width: 50,
          //       child: BarcodeWidget(
          //         barcode: Barcode.qrCode(),
          //         data: invoice.info.number,
          //       ),
          //     ),
          //   ],
          // ),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCariHesapUnvani(invoice.satisFatura),
              buildInvoiceInfo(invoice.satisFatura),
            ],
          ),
        ],
      );
  static Widget buildFooterh(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCariTutari(invoice.satisFatura),
              buildTotal(invoice),
            ],
          ),
        ],
      );

  static Widget buildCariHesapUnvani(SatisFatura satisFatura) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Cari Hesap Ünvanı:",
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text(satisFatura.firmaUnvani!),
        ],
      );

  static Widget buildCariTutari(SatisFatura satisFatura) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          buildText(
              title: "Yalnız:",
              value: satisFatura.tutarYazi!), // Yalnız Tutar ile değiştilecek
          buildText(
              title: "C.H Bakiye",
              value: Utils.formatPrice(satisFatura.bakiye!))
        ],
      );

  static Widget buildInvoiceInfo(SatisFatura info) {
    // final paymentTerms = '${info.dueDate.difference(info.date).inDays} days';
    final titles = <String>[
      'Fatura Tarihi:',
      'Fatura Türü:',
      // 'Payment Terms:',
      // 'Due Date:'
    ];
    final data = <String>[
      Utils.formatDate(info.tarih),
      "Toptan Satış Faturası",
      // paymentTerms,
      // Utils.formatDate(info.dueDate),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

  static Widget buildSupplierAddress(Supplier supplier) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(supplier.name, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text(supplier.address),
        ],
      );

  static Widget buildTitle(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Satış Faturası',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text(invoice.info.description),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildInvoice(Invoice invoice) {
    final headers = [
      'Ürün Kodu',
      'Ürün',
      'Miktar',
      'Birim Fiyat',
      'İsk. Brm Fyt',
      'Tutar'
    ];
    final data = invoice.items.map((item) {
      double iskTutar = item.birimFiyat -
          (item.birimFiyat * (invoice.satisFatura.iskontoOrani!) / 100);
      final total = item.birimFiyat * iskTutar;

      return [
        item.urunKodu,
        item.urunAdi,
        '${item.miktar}',
        '\₺ ${item.birimFiyat}',
        '₺$iskTutar',
        '\$ ${total.toStringAsFixed(2)}',
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.center,
        1: Alignment.center,
        2: Alignment.center,
        3: Alignment.center,
        4: Alignment.center,
        5: Alignment.center,
      },
    );
  }

  static Widget buildTotal(Invoice invoice) {
    final netTotal = invoice.items
        .map((item) => item.birimFiyat * item.miktar)
        .reduce((item1, item2) => item1 + item2);
    // final vatPercent = invoice.items.first.vat;
    const vatPercent = 8;
    final vat = netTotal * vatPercent;
    final total = netTotal + vat;

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Fatura Toplam',
                  value: Utils.formatPrice(netTotal),
                  unite: true,
                ),
                Divider(),
                buildText(
                  title: 'Fat. Ind. Tutarı',
                  value: Utils.formatPrice(vat),
                  unite: true,
                ),
                buildText(
                  title: "KDV'siz Toplam",
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: Utils.formatPrice(total),
                  unite: true,
                ),
                Divider(),
                buildText(
                  title: 'KDV Tutarı',
                  value: Utils.formatPrice(vat),
                  unite: true,
                ),
                buildText(
                  title: "Genel Toplam",
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: Utils.formatPrice(total),
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // static Widget buildFooter(Invoice invoice) => Column(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Divider(),
  //         SizedBox(height: 2 * PdfPageFormat.mm),
  //         buildSimpleText(title: 'Address', value: invoice.supplier.address),
  //         SizedBox(height: 1 * PdfPageFormat.mm),
  //         buildSimpleText(title: 'Paypal', value: invoice.supplier.paymentInfo),
  //       ],
  //     );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
