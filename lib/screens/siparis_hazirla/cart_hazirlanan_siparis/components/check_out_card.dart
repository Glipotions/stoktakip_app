import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:stoktakip_app/change_notifier_model/hazirlanan_siparis_bilgileri_data.dart';
import 'package:stoktakip_app/components/default_button.dart';
import 'package:stoktakip_app/functions/const_entities.dart';
import 'package:stoktakip_app/model/cari_hesap/cari_hesap.dart';
import 'package:stoktakip_app/model/hazirlanan_siparis/bulk_edit_prepared_order.dart';
import 'package:stoktakip_app/model/hazirlanan_siparis/complete_prepared_order.dart';
import 'package:stoktakip_app/model/hazirlanan_siparis/hazirlanan_siparis.dart';
import 'package:stoktakip_app/model/hazirlanan_siparis/hazirlanan_siparis_bilgileri.dart';
import 'package:stoktakip_app/services/api_services/alinan_siparis_api_service.dart';
import 'package:stoktakip_app/services/api_services/hazirlanan_siparis_api_service.dart';
import 'package:stoktakip_app/size_config.dart';
import 'package:pdf/widgets.dart' as pw;

class CheckoutCard extends StatefulWidget {
  const CheckoutCard({Key? key}) : super(key: key);

  @override
  State<CheckoutCard> createState() => _CheckoutCardState();
}

class _CheckoutCardState extends State<CheckoutCard>
    with TickerProviderStateMixin {
  final snackBar = const SnackBar(content: Text('Sipariş Hazırlandı!'));
  final snackBarSatisFaturaEkle = const SnackBar(
      content: Text('Sipariş Oluştururken 1 hata meydana geldi!'));

  var formKey = GlobalKey<FormState>();

  late AnimationController controller;

  bool _firstPress = true, returnDurum = false;
  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);
    super.initState();
  }

  final GlobalKey<ScaffoldMessengerState> snackbarKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _completeOrder() async {
    if (_firstPress) {
      _firstPress = false;
      int toplam = 0;
      returnDurum = false;
      List<String> eksikUrunler = [];

      for (var item in alinanSiparisBilgileriList) {
        var durum = hazirlananSiparisBilgileriList
            .any((element) => element.urunId == item.urunId);
        if (!durum) {
          toplam += 1;
          eksikUrunler.add(item.urunKodu.toString());
        }
      }

      await checkEksikOlanUrun(context, toplam, eksikUrunler);
      if (!returnDurum) {
        hazirlananSiparisSingle.kod = "X";
        hazirlananSiparisSingle.id =
            hazirlananSiparisBilgileriList.first.hazirlananSiparisId;
        hazirlananSiparisSingle.tarih = DateTime.now();
        hazirlananSiparisSingle.aciklama =
            siparisAciklama ?? "Mobilden Hazirlanan Siparis";

        // Prepare the DTO
        CompletePreparedOrderDto completeOrder = CompletePreparedOrderDto(
          hazirlananSiparis: hazirlananSiparisSingle,
          hazirlananSiparisBilgileriList:
              hazirlananSiparisBilgileriList.map((item) {
            item.familyAlinanSiparisBilgileriId =
                alinanSiparisBilgileriList.first.id;
            item.hazirlananSiparisId = hazirlananSiparisSingle.id;
            return item;
          }).toList(),
        );

        // Send the bulk API request
        var response =
            await HazirlananSiparisApiService.postCompletePreparedOrder(
                completeOrder);

        if (response.statusCode == 200) {
          var responseBody = json.decode(response.body);
          if (responseBody["success"]) {
            // Update local state as needed

            // Handle the rest of your logic here
            if (hazirlananSiparisSingle.isSeciliSiparis!) {
              int toplam = alinanSiparisBilgileriList.fold(
                  0, (sum, item) => sum + (item.kalanAdet ?? 0));
              if (toplam == 0) {
                await AlinanSiparisApiService.updateAlinanSiparisDurumById(
                    alinanSiparisSingle.id!);
              }
            }

            // TEMİZLİK KISMI
            hazirlananSiparisBilgileriList.clear();
            Provider.of<HazirlananSiparisBilgileriData>(context, listen: false)
                .saveListToSharedPref(hazirlananSiparisBilgileriGetIdList);

            faturaAciklama = null;
            cariHesapSingle =
                CariHesap(firma: null, bakiye: 0, id: cariHesapSingle.id);

            hazirlananSiparisSingle = HazirlananSiparis();

            Navigator.of(context).pop(true);
            Navigator.of(context).pop(true);

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(responseBody['Message'] ?? 'Error')));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(snackBarSatisFaturaEkle);
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Birden Fazla Tıklamalar Dikkate Alınmadı!')));
    }
  }

  void _editOrder() async {
    if (_firstPress) {
      _firstPress = false;

      int toplam = 0, kalanToplam = 0;
      returnDurum = false;
      List<String> eksikUrunler = [];
      List<HazirlananSiparisBilgileri> insertList = [];
      List<HazirlananSiparisBilgileri> updateList = [];

      for (var item in alinanSiparisBilgileriList) {
        var durum = hazirlananSiparisBilgileriGetIdList
            .any((element) => element.urunId == item.urunId);
        if (!durum) {
          toplam += 1;
          eksikUrunler.add(item.urunKodu.toString());
        }
        kalanToplam += item.kalanAdet ?? 0;
      }

      await checkEksikOlanUrun(context, toplam, eksikUrunler);
      if (!returnDurum) {
        var alinanSiparisBilgileriId = hazirlananSiparisBilgileriGetIdList
            .where((x) => x.alinanSiparisBilgileriId != null)
            .first
            .alinanSiparisBilgileriId;

        for (var urun in hazirlananSiparisBilgileriGetIdList) {
          urun.familyAlinanSiparisBilgileriId = alinanSiparisBilgileriId;

          if (urun.insert == true) {
            // Prepare for insertion
            urun.hazirlananSiparisId = hazirlananSiparisEdit.id;
            insertList.add(urun);
          } else if (urun.update == true) {
            // Prepare for update
            urun.dovizTuru = 1;
            updateList.add(urun);
          }
        }

        // Prepare the DTO
        BulkEditOrderDto bulkEditOrder = BulkEditOrderDto(
          hazirlananSiparis: hazirlananSiparisEdit,
          insertList: insertList,
          updateList: updateList,
        );

        // Send the bulk API request
        var response =
            await HazirlananSiparisApiService.postBulkEditPreparedOrder(
                bulkEditOrder);

        if (response.statusCode == 200) {
          var responseBody = json.decode(response.body);
          if (responseBody['success']) {
            // Handle successful response

            if (hazirlananSiparisEdit.isSeciliSiparis!) {
              if (kalanToplam == 0) {
                await AlinanSiparisApiService.updateAlinanSiparisDurumById(
                    hazirlananSiparisEdit.alinanSiparisId!);
              }
            }

            // TEMİZLİK KISMI
            hazirlananSiparisBilgileriSil();

            hazirlananSiparisBilgileriGetIdList.clear();
            Provider.of<HazirlananSiparisBilgileriData>(context, listen: false)
                .saveListToSharedPref(hazirlananSiparisBilgileriGetIdList);
            hazirlananSiparisSingle = HazirlananSiparis();

            Navigator.of(context).pop(true);
            Navigator.of(context).pop(true);

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    responseBody['Message'] ?? 'Order edited successfully.')));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    Text(responseBody['Message'] ?? 'Error editing order.')));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Failed to edit order. Please try again.')));
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Birden Fazla Tıklamalar Dikkate Alınmadı!')));
    }
  }

  // void _editOrder() async {
  //   if (_firstPress) {
  //     _firstPress = false;

  //     int toplam = 0, kalanToplam = 0;
  //     returnDurum = false;
  //     List<String> eksikUrunler = [];
  //     for (var item in alinanSiparisBilgileriList) {
  //       var durum = hazirlananSiparisBilgileriGetIdList
  //           .any((element) => element.urunId == item.urunId);
  //       if (!durum) {
  //         toplam += 1;
  //         eksikUrunler.add(item.urunKodu.toString());
  //       }
  //       kalanToplam += item.kalanAdet!;
  //     }

  //     await checkEksikOlanUrun(context, toplam, eksikUrunler);
  //     if (!returnDurum) {
  //       var alinanSiparisBilgileriId = hazirlananSiparisBilgileriGetIdList
  //           .where((x) => x.alinanSiparisBilgileriId != null)
  //           .first
  //           .alinanSiparisBilgileriId;
  //       for (var urun in hazirlananSiparisBilgileriGetIdList) {
  //         urun.familyAlinanSiparisBilgileriId = alinanSiparisBilgileriId;
  //         if (urun.insert == true) {
  //           await HazirlananSiparisApiService.postHazirlananSiparisBilgileri(
  //               urun);
  //           var entity = alinanSiparisBilgileriList
  //               .singleWhere((element) => element.urunId == urun.urunId);
  //           entity.dovizTuru = 1;
  //           await AlinanSiparisApiService.updateAlinanSiparisBilgileri(entity);
  //         } else if (urun.update!) {
  //           urun.dovizTuru = 1;
  //           await HazirlananSiparisApiService.updateHazirlananSiparisBilgileri(
  //               urun);
  //           // await UrunApiService.updateUrunStokById(
  //           //     urun.urunId, urun.ilaveEdilmis!, true);
  //           var entity = alinanSiparisBilgileriList
  //               .singleWhere((element) => element.urunId == urun.urunId);

  //           entity.dovizTuru = 1;
  //           await AlinanSiparisApiService.updateAlinanSiparisBilgileri(entity);
  //         }
  //       }
  //       if (kalanToplam == 0 && hazirlananSiparisEdit.isSeciliSiparis!) {
  //         await AlinanSiparisApiService.updateAlinanSiparisDurumById(
  //             hazirlananSiparisEdit.alinanSiparisId!);
  //       }

  //       hazirlananSiparisBilgileriSil();

  //       //TEMİZLİK KISMI

  //       hazirlananSiparisBilgileriGetIdList.clear();
  //       Provider.of<HazirlananSiparisBilgileriData>(context, listen: false)
  //           .saveListToSharedPref(hazirlananSiparisBilgileriGetIdList);
  //       hazirlananSiparisSingle = HazirlananSiparis();

  //       Navigator.of(context).pop(true);
  //       Navigator.of(context).pop(true);
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text('Birden Fazla Tıklamalar Dikkate Alınmadı!')));
  //   }
  // }

  Future<pw.ThemeData> pdfThemeData() async {
    final ttfRegular =
        await rootBundle.load("assets/fonts/roboto/Roboto-Regular.ttf");
    final ttfBold =
        await rootBundle.load("assets/fonts/roboto/Roboto-Bold.ttf");
    final ttfItalic =
        await rootBundle.load("assets/fonts/roboto/Roboto-Italic.ttf");
    final ttfBoldItalic =
        await rootBundle.load("assets/fonts/roboto/Roboto-BoldItalic.ttf");

    final fontRegular = pw.Font.ttf(ttfRegular);
    final fontBold = pw.Font.ttf(ttfBold);
    final fontItalic = pw.Font.ttf(ttfItalic);
    final fontBoldItalic = pw.Font.ttf(ttfBoldItalic);

    final theme = pw.ThemeData.withFont(
      base: fontRegular,
      bold: fontBold,
      italic: fontItalic,
      boldItalic: fontBoldItalic,
    );
    return theme;
  }

  void _printOrder() async {
    // Show a dialog to select sackNo options
    List<String> uniqueSackNos = hazirlananSiparisBilgileriList.isNotEmpty
        ? hazirlananSiparisBilgileriList
            .where((item) => item.sackNo != null)
            .map((item) => item.sackNo!)
            .toSet()
            .toList()
        : hazirlananSiparisBilgileriGetIdList
            .where((item) => item.sackNo != null)
            .map((item) => item.sackNo!)
            .toSet()
            .toList();

    uniqueSackNos.sort();

    List<String> selectedSackNos = [];

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Yazdırma Seçenekleri'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CheckboxListTile(
                      title: const Text('Tümünü Yazdır'),
                      value: selectedSackNos.length == uniqueSackNos.length,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedSackNos = List.from(uniqueSackNos);
                          } else {
                            selectedSackNos.clear();
                          }
                        });
                      },
                    ),
                    const Divider(),
                    ...uniqueSackNos.map((sackNo) {
                      return CheckboxListTile(
                        title: Text('Torba No: $sackNo'),
                        value: selectedSackNos.contains(sackNo),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              selectedSackNos.add(sackNo);
                            } else {
                              selectedSackNos.remove(sackNo);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cancel
              },
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                if (selectedSackNos.isEmpty) {
                  // If no selection, default to all
                  selectedSackNos = List.from(uniqueSackNos);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Tamam'),
            ),
          ],
        );
      },
    );

    if (selectedSackNos.isEmpty) {
      // User canceled the dialog
      return;
    }

    // Filter the list based on selectedSackNos
    List<HazirlananSiparisBilgileri> filteredList =
        hazirlananSiparisBilgileriList.isNotEmpty
            ? hazirlananSiparisBilgileriList.where((item) {
                if (selectedSackNos.contains(item.sackNo)) {
                  return true;
                }
                return false;
              }).toList()
            : hazirlananSiparisBilgileriGetIdList.where((item) {
                if (selectedSackNos.contains(item.sackNo)) {
                  return true;
                }
                return false;
              }).toList();

    if (filteredList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Seçilen sackNo\'ya ait ürün bulunamadı!')),
      );
      return;
    }

   final pdf = pw.Document();
final pageWidth = 100 * PdfPageFormat.mm; // Sayfa genişliği 100mm
final pageHeight = 250 * PdfPageFormat.mm; // Sayfa yüksekliği 250mm

// filteredList'i sackNo alanına göre gruplandırıyoruz
final groupedBySackNo = <String, List<HazirlananSiparisBilgileri>>{};
for (var item in filteredList) {
  final sackNo = item.sackNo ?? "1"; // Eğer sackNo yoksa 1 olarak varsayalım
  if (groupedBySackNo.containsKey(sackNo)) {
    groupedBySackNo[sackNo]!.add(item);
  } else {
    groupedBySackNo[sackNo] = [item];
  }
}

// Tüm sack grupları için sayfalar oluştur
int totalPieceSum = 0;
for (var entry in groupedBySackNo.entries) {
  final sackNo = entry.key;
  final items = entry.value;

  // Bu sayfadaki tüm ürünler için toplam miktarı hesapla
  final totalPiece = items.fold<int>(0, (sum, item) => sum + (item.miktar));
  totalPieceSum += totalPiece; // Genel toplam için ekle

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat(pageWidth, pageHeight),
      margin: pw.EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      theme: await pdfThemeData(),
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Sadece ilk sayfa için başlıklar
            if (sackNo == groupedBySackNo.keys.first)
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Cari Hesap', style: pw.TextStyle(fontSize: 10)),
                          pw.Text('Açıklama', style: pw.TextStyle(fontSize: 10)),
                        ],
                      ),
                      pw.Text(
                        '12.11.2024',
                        style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                ],
              ),

            // "Sack" Başlığı
            pw.Text(
              '$sackNo. SACK',
              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 5),

            // Tablo Başlıkları
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Container(width: 25 * PdfPageFormat.mm, child: pw.Text('CODE', textAlign: pw.TextAlign.center)),
                pw.Container(width: 60 * PdfPageFormat.mm, child: pw.Text('EXPLANATION', textAlign: pw.TextAlign.center)),
                pw.Container(width: 15 * PdfPageFormat.mm, child: pw.Text('PIECE', textAlign: pw.TextAlign.center)),
              ],
            ),
            pw.Divider(),

            // Tablo Satırları
            for (var item in items)
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Container(width: 25 * PdfPageFormat.mm, child: pw.Text(item.urunKodu ?? '', textAlign: pw.TextAlign.center)),
                  pw.Container(width: 60 * PdfPageFormat.mm, child: pw.Text(item.urunAdi ?? '', textAlign: pw.TextAlign.center)),
                  pw.Container(width: 15 * PdfPageFormat.mm, child: pw.Text(item.miktar.toString(), textAlign: pw.TextAlign.center)),
                ],
              ),
            pw.Divider(),

            // Sadece son sayfa için "Total Piece" alanı
            if (sackNo == groupedBySackNo.keys.last)
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    'Total Piece: $totalPieceSum',
                    style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
          ],
        );
      },
    ),
  );
}
    // Print the PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: formKey,
      padding: EdgeInsets.symmetric(
          vertical: getProportionateScreenWidth(15),
          horizontal: getProportionateScreenWidth(30)),
      // height: 174,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.15),
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getProportionateScreenHeight(5)),
            buildTextRich("Toplam Adet: ${toplamMiktar()}", Colors.teal),
            SizedBox(height: getProportionateScreenHeight(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: getProportionateScreenWidth(190),
                  child: hazirlananSiparisDurum == true
                      ? DefaultButton(
                          text: "Siparişi Tamamla",
                          press: _completeOrder,
                        )
                      : DefaultButton(
                          text: "Düzenle",
                          press: _editOrder,
                        ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: getProportionateScreenWidth(100),
                  child: DefaultButton(
                    text: "Yazdır",
                    press: _printOrder,
                    // color: Colors.blue, // Optional: Different color for print
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Text buildTextRich(String _text, Color renk) {
    return Text.rich(
      TextSpan(
        text: _text,
        style: TextStyle(fontSize: 16, color: renk),
      ),
    );
  }

  String toplamMiktar() {
    int toplam = 0;
    setState(() {
      if (hazirlananSiparisDurum != null && hazirlananSiparisDurum!) {
        for (var item in hazirlananSiparisBilgileriList) {
          toplam += item.miktar;
        }
      } else {
        for (var item in hazirlananSiparisBilgileriGetIdList) {
          toplam += item.miktar;
        }
      }
    });
    return toplam.toString();
  }

  void hazirlananSiparisBilgileriSil() async {
    for (var urunDelete in hazirlananSiparisBilgileriDeleteList) {
      urunDelete.dovizTuru = 1;

      var entity = alinanSiparisBilgileriList
          .singleWhere((element) => element.urunId == urunDelete.urunId);
      entity.dovizTuru = 1;
      await AlinanSiparisApiService.updateAlinanSiparisBilgileri(entity);
      await HazirlananSiparisApiService.deleteHazirlananSiparisBilgileri(
          urunDelete);
    }
    hazirlananSiparisBilgileriDeleteList = [];
  }

  checkEksikOlanUrun(
    BuildContext context,
    int toplam,
    List<String> urunler,
  ) async {
    if (toplam > 0) {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('GİRİLMEYEN ÜRÜNLER VAR!'),
              content: Text(
                  'GİRİLMEYEN ÜRÜNLER: $urunler \n\nYİNE DE DEĞİŞİKLİK YAPMADAN SİPARİŞİ TAMAMLAMAK İSTER MİSİNİZ?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    _firstPress = true;
                    returnDurum = true;
                    Navigator.pop(context, 'Hayır');
                  },
                  child: const Text('Hayır'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'Evet');
                    returnDurum = false;
                  },
                  child: const Text('Evet'),
                ),
              ],
            );
          });
    }
  }
}
