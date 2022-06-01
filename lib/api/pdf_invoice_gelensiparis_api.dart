import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:stoktakip_app/api/pdf_api.dart';
import 'package:stoktakip_app/model/gelen_urun_siparis/gelen_siparis.dart';
import 'package:stoktakip_app/model/other/invoice.dart';
import 'package:stoktakip_app/model/other/supplier.dart';
import 'package:intl/date_symbol_data_local.dart';
// import 'package:google_fonts/google_fonts.dart';

// Future<Font> fontBold() async {
//   final fontBold = await rootBundle.load("assets/fonts/muli/Muli-Bold.ttf");
//   return pw.Font.ttf(fontBold);
// }

class PdfInvoiceGelenSiparisApi {
  static Future<File> generate(InvoiceGelenSiparis invoice) async {
    final pdf = pw.Document();
// pdf.document.fonts.
    final fontBold = await rootBundle.load("assets/fonts/muli/Muli-Bold.ttf");
    final fontItalic =
        await rootBundle.load("assets/fonts/roboto/Roboto-Regular.ttf");
    final fontBoldRoboto =
        await rootBundle.load("assets/fonts/roboto/Roboto-Bold.ttf");

    final ttfBold = pw.Font.ttf(fontBold);
    // final ttfBoldRoboto = pw.Font.ttf(fontBoldRoboto);
    final ttfItalic = pw.Font.ttf(fontItalic);

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(invoice, ttfBold, ttfItalic),
        SizedBox(height: 1 * PdfPageFormat.cm),
        buildTitle(invoice),
        buildInvoice(invoice, ttfBold, ttfItalic),
        Divider(),
        // buildCariTutari(invoice.gelenSiparis),
        // buildFooter(invoice, ttfBold, ttfItalic, ttfBoldRoboto),
      ],
    ));

    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static Widget buildHeader(
          InvoiceGelenSiparis invoice, Font fontBold, Font fontItalic) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCariHesapUnvani(invoice.gelenSiparis, fontBold, fontItalic),
              buildInvoiceInfo(invoice.gelenSiparis, fontItalic),
            ],
          ),
        ],
      );

  static Widget buildCariHesapUnvani(
          GelenSiparis gelenSiparis, Font fontBold, Font fontItalic) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Cari Hesap Ünvanı:",
              style: TextStyle(fontWeight: FontWeight.bold, font: fontBold)),
          Text(gelenSiparis.siparisAdi!, style: TextStyle(font: fontItalic)),
        ],
      );

  static Widget buildInvoiceInfo(GelenSiparis info, Font fontItalic) {
    initializeDateFormatting('tr');
    // final paymentTerms = '${info.dueDate.difference(info.date).inDays} days';
    final titles = <String>[
      'Fatura Adı:',
      'Fatura Türü:',
      // 'Payment Terms:',
      // 'Due Date:'
    ];
    final data = <String>[
      info.siparisAdi!,
      // Jiffy(info.tarih).yMd,
      "Gelen Siparis",
      // paymentTerms,
      // Utils.formatDate(info.dueDate),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(
            title: title,
            value: value,
            width: 200,
            font: fontItalic,
            unite: true);
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

  static Widget buildTitle(InvoiceGelenSiparis invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hazırlanan Sipariş',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          // Text(invoice.info.description),
          // SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildInvoice(
      InvoiceGelenSiparis invoice, Font fontBold, Font fontItalic) {
    final headers = [
      'Ürün Kodu',
      'Ürün',
      'Miktar',
      // 'Birim Fiyat',
      // 'Isk. Brm Fyt',
      // 'Tutar'
    ];
    final data = invoice.items.map((item) {
      // double iskTutar = item.birimFiyat -
      //     (item.birimFiyat * (invoice.gelenSiparis.iskontoOrani!) / 100);
      // final total = item.miktar * item.birimFiyat;

      return [
        item.urunKodu,
        item.urunAdi,
        '${item.miktar}',
        // '₺${item.birimFiyat}',
        // '₺${iskTutar.toStringAsFixed(2)}',
        // '₺${total.toStringAsFixed(2)}',
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle:
          TextStyle(fontWeight: FontWeight.bold, fontSize: 9, font: fontBold),
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellHeight: 20,
      cellStyle: pw.TextStyle(fontSize: 9, font: fontItalic),
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

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(
      fontWeight: FontWeight.bold,
    );

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
    // TextStyle? valueStyle,
    bool unite = false,
    Font? font,
  }) {
    final style = titleStyle ??
        TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 9,
          font: font,
        );
    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(
            value,
            style: unite ? style : null,
          ),
        ],
      ),
    );
  }
}
