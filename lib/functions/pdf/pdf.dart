// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/services.dart' show rootBundle;

// import 'package:flutter/material.dart';
// import 'package:stoktakip_app/functions/const_entities.dart';
// import 'package:stoktakip_app/model/satis_fatura.dart';
// import 'package:stoktakip_app/services/api.services.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart';

// import 'mobile.dart' if (dart.library.html) 'web.dart';

// class MyPdfPage extends StatefulWidget {
//   const MyPdfPage({Key? key}) : super(key: key);

//   @override
//   _MyPdfPageState createState() => _MyPdfPageState();
// }

// class _MyPdfPageState extends State<MyPdfPage> {
//   Future<List> _getSatisFaturas() async {
//     await APIServices.fetchSatisFatura().then((response) {
//       setState(() {
//         dynamic list = json.decode(response.body);
//         // List data = list['data'];
//         List data = list;
//         satisFaturaList =
//             data.map((model) => SatisFatura.fromJson(model)).toList();
//       });
//     });
//     return satisFaturaList;
//   }

//   Future<void> initStateAsync() async {
//     await _getSatisFaturas();
//   }

//   @override
//   void initState() {
//     initStateAsync();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: ElevatedButton(
//           child: Text('Create PDF'),
//           onPressed: _createPDF,
//         ),
//       ),
//     );
//   }
// }

// Future<void> _createPDF() async {
//   PdfDocument document = PdfDocument();
//   // final page = document.pages.add();

//   // page.graphics.drawString('Welcome to PDF Succinctly!',
//   //     PdfStandardFont(PdfFontFamily.helvetica, 30));

//   // page.graphics.drawImage(PdfBitmap(await _readImageData('Pdf_Succinctly.jpg')),
//   //     Rect.fromLTWH(0, 100, 440, 550));

//   PdfGrid grid = PdfGrid();
//   grid.style = PdfGridStyle(
//     font: PdfStandardFont(PdfFontFamily.helvetica, 8),
//     cellPadding: PdfPaddings(left: 5, right: 2, top: 2, bottom: 2),
//   );

//   grid.columns.add(count: 3);
//   grid.headers.add(1);

//   PdfGridRow header = grid.headers[0];
//   header.cells[0].value = 'Kod';
//   header.cells[1].value = 'Miktar';
//   header.cells[2].value = 'Birim';
//   // header.cells[3].value = 'Tutar';

//   PdfGridRow row = grid.rows.add();
//   row.cells[0].value = "Musteri :";
//   row.cells[1].value = "Hamza";
//   row.cells[2].value = "s";
//   // row.cells[2].value = item.toplamTutar.toString();

//   PdfGridRowStyle rowStyle = PdfGridRowStyle(
//       backgroundBrush: PdfBrushes.aqua, textBrush: PdfBrushes.darkOrange);

//   // PdfBorders border = PdfBorders(
//   //     left: PdfPen(PdfColor(0, 0, 0), width: 2),
//   //     top: PdfPen(PdfColor(0, 0, 0), width: 3),
//   //     bottom: PdfPen(PdfColor(0, 0, 0), width: 4),
//   //     right: PdfPen(PdfColor(255, 255, 255), width: 5));

//   // PdfStringFormat format = PdfStringFormat(
//   //     alignment: PdfTextAlignment.center,
//   //     lineAlignment: PdfVerticalAlignment.bottom,
//   //     wordSpacing: 10);
//   // PdfGridCellStyle cellStyle = PdfGridCellStyle(
//   //   backgroundBrush: PdfBrushes.lightYellow,
//   //   borders: border,
//   //   cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
//   //   font: PdfStandardFont(PdfFontFamily.timesRoman, 17),
//   //   format: format,
//   //   textBrush: PdfBrushes.white,
//   //   textPen: PdfPens.orange,
//   // );

//   // for (var item in satisFaturaList) {
//   //   row = grid.rows.add();
//   //   row.cells[0].value = "${item.faturaTuru}";
//   //   row.cells[1].value = item.dovizTutar.toString();
//   //   row.cells[2].value = item.toplamTutar.toString();
//   //   // row.style = rowStyle;
//   //   // row.cells[0].style = cellStyle;
//   //   // row.cells[1].style = cellStyle;
//   //   // row.cells[2].style = cellStyle;
//   // }
//   PdfGridStyle gridStyle = PdfGridStyle(
//     cellSpacing: 2,
//     cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
//     borderOverlapStyle: PdfBorderOverlapStyle.inside,
//     backgroundBrush: PdfBrushes.white,
//     textPen: PdfPens.black,
//     textBrush: PdfBrushes.black,
//     font: PdfStandardFont(PdfFontFamily.timesRoman, 7),
//   );
//   grid.rows.applyStyle(gridStyle);
//   grid.draw(
//       page: document.pages.add(), bounds: const Rect.fromLTWH(0, 0, 0, 0));

//   List<int> bytes = document.save();
//   document.dispose();

//   saveAndLaunchFile(bytes, 'Output.pdf');
// }

// Future<Uint8List> _readImageData(String name) async {
//   final data = await rootBundle.load('images/$name');
//   return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
// }
