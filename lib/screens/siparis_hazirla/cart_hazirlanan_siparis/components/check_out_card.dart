import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stoktakip_app/functions/extentions/string_extentions.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
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

  BlueThermalPrinter printer = BlueThermalPrinter.instance;
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;
  bool _connected = false;
  bool isSimulator = false;

  var formKey = GlobalKey<FormState>();

  late AnimationController controller;

  bool _firstPress = true, returnDurum = false;
  String? _idempotencyKey;
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

    var uuid = Uuid();
    _idempotencyKey = uuid.v4();
    
    // Check if running on simulator
    checkSimulator();
  }

  // Check if running on simulator
  void checkSimulator() async {
    try {
      devices = await printer.getBondedDevices();
      isSimulator = false;
    } catch (e) {
      isSimulator = true;
      _connected = false;
    }
    setState(() {});
  }

  // Initialize the printer
  void initPrinter() async {
    if (isSimulator) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Simülatörde yazıcı kullanılamaz. Lütfen fiziksel cihaz kullanın.')),
      );
      return;
    }

    try {
      devices = await printer.getBondedDevices();
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Yazıcı başlatılırken hata oluştu. Bluetooth açık olduğundan emin olun.')),
      );
    }
  }

  // Connect to printer
  void connectToPrinter(BluetoothDevice device) async {
    try {
      if (device != null) {
        bool? isConnected = await printer.isConnected;
        if (isConnected == true) {
          setState(() {
            selectedDevice = device;
            _connected = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Yazıcı zaten bağlı: ${device.name}')),
          );
          return;
        }
        
        await printer.connect(device);
        setState(() {
          selectedDevice = device;
          _connected = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Yazıcıya bağlandı: ${device.name}')),
        );
      }
    } catch (e) {
      setState(() {
        _connected = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Yazıcıya bağlanırken hata: $e')),
      );
    }
  }

  final snackbarKey = GlobalKey<ScaffoldMessengerState>();

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
          idempotencyKey: _idempotencyKey!,
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
          deleteList: hazirlananSiparisBilgileriDeleteList,
          idempotencyKey: _idempotencyKey!
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

  // Convert Turkish characters to English equivalents
  String convertTurkishToEnglish(String text) {
    const turkishChars = ['ı', 'ğ', 'İ', 'Ğ', 'ç', 'Ç', 'ş', 'Ş', 'ö', 'Ö', 'ü', 'Ü'];
    const englishChars = ['i', 'g', 'I', 'G', 'c', 'C', 's', 'S', 'o', 'O', 'u', 'U'];
    
    String result = text;
    for (int i = 0; i < turkishChars.length; i++) {
      result = result.replaceAll(turkishChars[i], englishChars[i]);
    }
    return result;
  }

  // Format text to fit within specified width
  List<String> wrapText(String text, int width) {
    List<String> lines = [];
    while (text.length > width) {
      int spaceIndex = text.substring(0, width).lastIndexOf(' ');
      if (spaceIndex == -1) {
        spaceIndex = width;
      }
      lines.add(text.substring(0, spaceIndex).trim());
      text = text.substring(spaceIndex).trim();
    }
    if (text.isNotEmpty) {
      lines.add(text);
    }
    return lines;
  }

  // Print formatted columns with proper width and alignment
  Future<void> printFormattedColumns(String code, String explanation, String piece) async {
    const int leftMargin = 2;      // 1.5mm margin
    const int codeWidth = 12;      // ~20.5mm
    const int explanationWidth = 45; // ~66mm
    const int pieceWidth = 2;      // ~10mm
    
    // Convert Turkish characters
    code = convertTurkishToEnglish(code);
    explanation = convertTurkishToEnglish(explanation);
    
    // Wrap long explanation text
    List<String> wrappedExplanation = wrapText(explanation, explanationWidth);
    
    // Print first line with all columns
    String line = '${' ' * leftMargin}${code.padRight(codeWidth)}|${wrappedExplanation[0].padRight(explanationWidth)}|${piece.padLeft(pieceWidth)}';
    await printer.printCustom(line, 1, 0);
    
    // Print remaining lines of explanation if any
    for (int i = 1; i < wrappedExplanation.length; i++) {
      String continuationLine = '${' ' * leftMargin}${''.padRight(codeWidth)}|${wrappedExplanation[i].padRight(explanationWidth)}|${''.padRight(pieceWidth)}';
      await printer.printCustom(continuationLine, 1, 0);
    }
  }

  Future<void> _printOrder() async {
    if (isSimulator) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Simülatörde yazıcı kullanılamaz. Lütfen fiziksel cihaz kullanın.')),
      );
      return;
    }

    if (!_connected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen önce yazıcıya bağlanın')),
      );
      return;
    }

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
                Navigator.of(context).pop();
              },
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                if (selectedSackNos.isEmpty) {
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
      return;
    }

    try {
      // Filter the list based on selectedSackNos
      List<HazirlananSiparisBilgileri> filteredList =
          hazirlananSiparisBilgileriList.isNotEmpty
              ? hazirlananSiparisBilgileriList.where((item) {
                  return selectedSackNos.contains(item.sackNo);
                }).toList()
              : hazirlananSiparisBilgileriGetIdList.where((item) {
                  return selectedSackNos.contains(item.sackNo);
                }).toList();

      if (filteredList.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Seçilen sackNo\'ya ait ürün bulunamadı!')),
        );
        return;
      }

      // Group items by sackNo
      final groupedBySackNo = <String, List<HazirlananSiparisBilgileri>>{};
      for (var item in filteredList) {
        final sackNo = item.sackNo ?? "1";
        if (groupedBySackNo.containsKey(sackNo)) {
          groupedBySackNo[sackNo]!.add(item);
        } else {
          groupedBySackNo[sackNo] = [item];
        }
      }

      int totalPieceSum = 0;

      // Print header once
      await printer.printNewLine();
      await printer.printNewLine();  // Extra line for 1.5mm spacing

      const totalWidth = 66;  // Total width in characters
      final separator = ' ' * 2 + '-' * (totalWidth - 2);  // Include left margin in separator

      // Print header with CARI HESAP and date on the same line
      var date=DateTime.now();
      final dateStr = '${date.day}-${date.month}-${date.year}';
      const headerText = "CURRENT ACCOUNT";
      // Ensure date stays on same line by calculating exact position
      final headerLine = '  $headerText${' '.repeat(totalWidth - headerText.length - dateStr.length - 2)}$dateStr';
      await printer.printCustom(headerLine, 2, 0);  
      await printer.printNewLine();
      
      await printer.printCustom('  DESCRIPTION', 2, 0);  
      await printer.printNewLine();

      // Print each sack group
      for (var entry in groupedBySackNo.entries) {
        final sackNo = entry.key;
        final items = entry.value;

        final totalPiece = items.fold<int>(0, (sum, item) => sum + (item.miktar));
        totalPieceSum += totalPiece;
        // Print sack header
        await printer.printCustom("  $sackNo. SACK".padLeft(30), 2, 1);
        await printer.printNewLine();

        // Print table header with adjusted widths
        final headerLine = '${' ' * 2}${'CODE'.padRight(12)}|${'EXPLANATION'.padRight(45)}|PIECE';
        await printer.printCustom(headerLine, 2, 0);  
        await printer.printCustom(separator, 1, 0);

        // Print items
        for (var item in items) {
          await printFormattedColumns(
            item.urunKodu ?? '',
            item.urunAdi ?? '',
            item.miktar.toString()
          );
          await printer.printCustom(separator, 1, 0);
        }
        await printer.printNewLine();
      }

      // Print total at the end
      final totalLine = '${'${' ' * 2}${' '.padRight(45)} TOTAL PIECE'}: ${totalPieceSum.toString().padLeft(1)}';
      await printer.printCustom(totalLine, 2, 0);  
      await printer.printNewLine();
      await printer.printNewLine();
      await printer.paperCut();

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Yazdırma sırasında hata: $e')),
      );
    }
  }

  Future<void> _showPrinterSelectionDialog() async {
    if (isSimulator) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Simülatörde yazıcı kullanılamaz. Lütfen fiziksel cihaz kullanın.')),
      );
      return;
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Yazıcı Seç'),
          content: SizedBox(
            width: double.maxFinite,
            child: devices.isEmpty
                ? const Center(child: Text('Eşleştirilmiş yazıcı bulunamadı'))
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: devices.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(devices[index].name ?? 'Bilinmeyen Cihaz'),
                        subtitle: Text(devices[index].address ?? ''),
                        onTap: () {
                          connectToPrinter(devices[index]);
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yenile'),
              onPressed: () async {
                devices = await printer.getBondedDevices();
                setState(() {});
              },
            ),
            TextButton(
              child: const Text('İptal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenWidth(15),
        horizontal: getProportionateScreenWidth(20),
      ),
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
            // Total Amount Display
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(10),
                vertical: getProportionateScreenWidth(8),
              ),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.teal,
                    size: getProportionateScreenWidth(24),
                  ),
                  SizedBox(width: getProportionateScreenWidth(8)),
                  Text(
                    "Toplam Adet: ${toplamMiktar()}",
                    style: const TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            
            // Bottom Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Main Action Button (Complete/Edit)
                Expanded(
                  flex: 4,
                  child: Container(
                    height: getProportionateScreenHeight(55),
                    child: hazirlananSiparisDurum == true
                        ? DefaultButton(
                            text: "Siparişi Tamamla",
                            press: _completeOrder,
                            color: Colors.white,
                          )
                        : DefaultButton(
                            text: "Düzenle",
                            press: _editOrder,
                            color: Colors.white,
                          ),
                  ),
                ),
                SizedBox(width: getProportionateScreenWidth(8)),
                
                // Print Button
                Expanded(
                  flex: 3,
                  child: Container(
                    height: getProportionateScreenHeight(55),
                    child: DefaultButton(
                      text: "Yazdır",
                      press: isSimulator || !_connected ? null : _printOrder,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: getProportionateScreenWidth(8)),
                
                // Printer Connection Button
                Expanded(
                  flex: 3,
                  child: Container(
                    height: getProportionateScreenHeight(55),
                    child: DefaultButton(
                      text: isSimulator 
                          ? "Simülatör" 
                          : (_connected ? "Bağlı ✓" : "Yazıcı"),
                      press: _showPrinterSelectionDialog,
                      color: Colors.white,
                    ),
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
