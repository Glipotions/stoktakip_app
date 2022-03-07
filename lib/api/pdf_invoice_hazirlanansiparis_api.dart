import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:stoktakip_app/api/pdf_api.dart';
import 'package:stoktakip_app/model/hazirlanan_siparis/hazirlanan_siparis.dart';
import 'package:stoktakip_app/model/other/invoice.dart';
import 'package:stoktakip_app/model/other/supplier.dart';
import 'package:intl/date_symbol_data_local.dart';
// import 'package:google_fonts/google_fonts.dart';

// Future<Font> fontBold() async {
//   final fontBold = await rootBundle.load("assets/fonts/muli/Muli-Bold.ttf");
//   return pw.Font.ttf(fontBold);
// }

class PdfInvoiceHazirlananSiparisApi {
  static Future<File> generate(InvoiceHazirlananSiparis invoice) async {
    final pdf = pw.Document();
// pdf.document.fonts.
    final fontBold = await rootBundle.load("assets/fonts/muli/Muli-Bold.ttf");
    final fontItalic =
        await rootBundle.load("assets/fonts/roboto/Roboto-Regular.ttf");
    final fontBoldRoboto =
        await rootBundle.load("assets/fonts/roboto/Roboto-Bold.ttf");

    final ttfBold = pw.Font.ttf(fontBold);
    final ttfBoldRoboto = pw.Font.ttf(fontBoldRoboto);
    final ttfItalic = pw.Font.ttf(fontItalic);

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(invoice, ttfBold, ttfItalic),
        SizedBox(height: 1 * PdfPageFormat.cm),
        buildTitle(invoice),
        buildInvoice(invoice, ttfBold, ttfItalic),
        Divider(),
        // buildCariTutari(invoice.hazirlananSiparis),
        // buildFooter(invoice, ttfBold, ttfItalic, ttfBoldRoboto),
      ],
    ));

    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static Widget buildHeader(
          InvoiceHazirlananSiparis invoice, Font fontBold, Font fontItalic) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCariHesapUnvani(
                  invoice.hazirlananSiparis, fontBold, fontItalic),
              buildInvoiceInfo(invoice.hazirlananSiparis, fontItalic),
            ],
          ),
        ],
      );
  // static Widget buildFooter(InvoiceHazirlananSiparis invoice, Font fontBold,
  //     Font fontItalic, Font fontBoldRoboto) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       SizedBox(height: 0.5 * PdfPageFormat.cm),
  //       Row(
  //         crossAxisAlignment: CrossAxisAlignment.end,
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           pw.Flexible(
  //               child:
  //                   buildCariTutari(invoice.hazirlananSiparis, fontBold, fontItalic),
  //               flex: 1),
  //           pw.Flexible(child: buildTotal(invoice, fontBoldRoboto), flex: 1),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  static Widget buildCariHesapUnvani(HazirlananSiparis hazirlananSiparis,
          Font fontBold, Font fontItalic) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Cari Hesap Ünvanı:",
              style: TextStyle(fontWeight: FontWeight.bold, font: fontBold)),
          Text(hazirlananSiparis.siparisAdi!,
              style: TextStyle(font: fontItalic)),
        ],
      );

  // static Widget buildCariTutari(
  //     HazirlananSiparis hazirlananSiparis, Font fontBold, Font fontItalic) {
  //   var number = NumberFormat("#,##0.00", "tr");
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     children: [
  //       buildText(
  //           title: "Yalnız:",
  //           value: hazirlananSiparis.tutarYazi!,
  //           unite: true,
  //           font: fontItalic),
  //       Divider(), // Yalnız Tutar ile değiştilecek
  //       buildText(
  //           title: "C.H Bakiye",
  //           value: '₺${number.format(hazirlananSiparis.bakiye!.toDouble())}',
  //           unite: true,
  //           font: fontItalic)
  //     ],
  //   );
  // }

  static Widget buildInvoiceInfo(HazirlananSiparis info, Font fontItalic) {
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
      "Hazirlanan Siparis",
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

  static Widget buildTitle(InvoiceHazirlananSiparis invoice) => Column(
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
      InvoiceHazirlananSiparis invoice, Font fontBold, Font fontItalic) {
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
      //     (item.birimFiyat * (invoice.hazirlananSiparis.iskontoOrani!) / 100);
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

  // static Widget buildTotal(InvoiceHazirlananSiparis invoice, Font fontBold) {
  //   final netTotal = invoice.items
  //       .map((item) => (item.birimFiyat) * item.miktar)
  //       .reduce((item1, item2) => item1 + item2);
  //   final vatTotal = invoice.hazirlananSiparis.kdvTutari;
  //   // final iskontoOrani = invoice.hazirlananSiparis.iskontoOrani!;
  //   final iskontoTutari = invoice.hazirlananSiparis.iskontoTutari!;
  //   final kdvsizToplam = invoice.hazirlananSiparis.kdvHaricTutar! - iskontoTutari;
  //   final total = invoice.hazirlananSiparis.toplamTutar!;
  //   var number = NumberFormat("#,##0.00", "tr");
  //   return Container(
  //     alignment: Alignment.centerLeft,
  //     child: Row(
  //       children: [
  //         Spacer(flex: 1),
  //         Expanded(
  //           flex: 4,
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               buildText(
  //                   title: 'Fatura Toplam',
  //                   value: '₺${number.format(netTotal.toDouble())}',
  //                   unite: true,
  //                   font: fontBold),
  //               Divider(),
  //               buildText(
  //                 title: 'Fat. Ind. Tutar',
  //                 value: '₺${number.format(iskontoTutari)}',
  //                 unite: true,
  //                 font: fontBold,
  //               ),
  //               buildText(
  //                 title: "KDV'siz Toplam",
  //                 titleStyle: TextStyle(
  //                   fontSize: 9,
  //                   fontWeight: FontWeight.bold,
  //                   font: fontBold,
  //                 ),
  //                 value: '₺${number.format(kdvsizToplam)}',
  //                 unite: true,
  //               ),
  //               Divider(),
  //               buildText(
  //                 title: 'KDV Tutar',
  //                 value: '₺${number.format(vatTotal)}',
  //                 unite: true,
  //                 font: fontBold,
  //               ),
  //               buildText(
  //                 title: "Genel Toplam",
  //                 titleStyle: TextStyle(
  //                   fontSize: 9,
  //                   fontWeight: FontWeight.bold,
  //                   font: fontBold,
  //                 ),
  //                 value: '₺${number.format(total)}',
  //                 // value: Utils.formatPrice(total),
  //                 unite: true,
  //               ),
  //               SizedBox(height: 1 * PdfPageFormat.mm),
  //               Container(height: 1, color: PdfColors.grey400),
  //               SizedBox(height: 0.5 * PdfPageFormat.mm),
  //               Container(height: 1, color: PdfColors.grey400),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
