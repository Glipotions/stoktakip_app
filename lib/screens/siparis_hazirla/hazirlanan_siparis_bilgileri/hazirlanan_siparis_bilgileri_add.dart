import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:stoktakip_app/components/default_button.dart';
import 'package:stoktakip_app/const/text_const.dart';
import 'package:stoktakip_app/functions/const_entities.dart';
import 'package:stoktakip_app/functions/general_functions.dart';
import 'package:stoktakip_app/functions/will_pop_scope_back_function.dart';
import 'package:stoktakip_app/model/hazirlanan_siparis/hazirlanan_siparis_bilgileri.dart';
import 'package:stoktakip_app/model/satis_fatura/satis_fatura.dart';
import 'package:stoktakip_app/model/urun/urun.dart';
import 'package:stoktakip_app/model/urun/urun_barkod_bilgileri.dart';
import 'package:stoktakip_app/screens/siparis_hazirla/cart_hazirlanan_siparis/cart_screen.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:stoktakip_app/screens/siparis_hazirla/hazirlanan_siparis_bilgileri/components/check_out_card.dart';
import 'package:stoktakip_app/services/api_services/urun_api_service.dart';
import 'package:stoktakip_app/size_config.dart';

// ignore: must_be_immutable
class HazirlananSiparisBilgileriAdd extends StatefulWidget {
  static String routeName = "/hazirlanan-siparis-bilgileri-add";

  List<SatisFatura>? satisFaturas;
  HazirlananSiparisBilgileriAdd({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HazirlananSiparisBilgileriAddState();
  }
}

class _HazirlananSiparisBilgileriAddState
    extends State<HazirlananSiparisBilgileriAdd> {
  final snackBarUrunEkle =
      const SnackBar(content: Text("Ürün Başarıyla Eklendi."));
  final snackBarKontrol = const SnackBar(content: Text("Ürün Bulunamadı."));

  String? lastInputValue;
  ByteData? resimData;

  var formKey = GlobalKey<FormState>();
  var barkodController = TextEditingController(),
      kdvHaricTutarController = TextEditingController(),
      urunKoduController = TextEditingController(),
      urunAdiController = TextEditingController(),
      birimFiyatController = TextEditingController(),
      miktarController = TextEditingController(),
      adetController = TextEditingController(),
      paketIciAdetController = TextEditingController(),
      paketSayisiController = TextEditingController();

  final _adetFocus = FocusNode();

  @override
  void dispose() {
    barkodController.dispose();
    kdvHaricTutarController.dispose();
    urunKoduController.dispose();
    urunAdiController.dispose();
    birimFiyatController.dispose();
    miktarController.dispose();
    adetController.dispose();
    paketIciAdetController.dispose();
    paketSayisiController.dispose();
    _adetFocus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    formKey;
    super.initState();
  }

  // List<UrunBilgileri> hazirlananSiparisBilgileriList = [];
  var urunBarkodBilgileri = <UrunBarkodBilgileri>[];
  var urun = <Urun>[];
  int? _urunId, _miktar, _tutar, _faturaId = buildId();
  double? _birimFiyat, _kdvHaricTutar, _kdvTutari;
  bool checkUrunItBeAdded = false;
  // int kdvHaricTutar = _miktar * _birimFiyat;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? result = await onBackPressedCancelFatura(
            context, "Hazırlanan Sipariş Bilgileri");
        result ??= false;
        if (result) {
          hazirlananSiparisBilgileriList.clear();
        }
        return result;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Hazırlanan Ürün Ekle",
            style: kMetinStili,
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                  height: 150.0,
                  width: 30.0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, CartScreenHazirlananSiparis.routeName);
                    },
                    child: Stack(
                      children: <Widget>[
                        const IconButton(
                          icon: Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                          ),
                          onPressed: null,
                        ),
                        hazirlananSiparisBilgileriList.isEmpty &&
                                hazirlananSiparisBilgileriGetIdList.isEmpty
                            ? Container()
                            : Positioned(
                                child: Stack(
                                children: <Widget>[
                                  Icon(Icons.shopping_cart_outlined,
                                      size: getProportionateScreenHeight(30),
                                      color: Colors.red[600]),
                                  Positioned(
                                      top: -3.0,
                                      right: -3.0,
                                      child: Center(
                                        child: Text(
                                          {
                                            hazirlananSiparisDurum == true
                                                ? hazirlananSiparisBilgileriList
                                                    .length
                                                : hazirlananSiparisBilgileriGetIdList
                                                    .length
                                          }.toString(),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )),
                                ],
                              )),
                      ],
                    ),
                  )),
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(2),
          child: Container(
            margin: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // buildIdBuild(),
                  buildBarcode(),
                  SizedBox(height: getProportionateScreenHeight(10)),
                  buildUrunKodu(),
                  SizedBox(height: getProportionateScreenHeight(10)),
                  buildUrunAdi(),
                  SizedBox(height: getProportionateScreenHeight(10)),
                  // buildBirimFiyati(),
                  // SizedBox(height: getProportionateScreenHeight(10)),
                  Row(
                    children: <Widget>[
                      Expanded(child: buildPakettekiAdetSayisi()),
                      Expanded(child: buildPaketSayisi()),
                    ],
                  ),
                  SizedBox(height: getProportionateScreenHeight(10)),
                  buildAdet(),
                  SizedBox(height: getProportionateScreenHeight(10)),
                  buildAddButton(),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const CheckoutCard(),
      ),
    );
  }

  Widget buildBarcode() {
    return SizedBox(
      key: UniqueKey(),
      height: 60,
      // decoration: BoxDecorationSettings(),
      child: Row(
        children: [
          Flexible(
            flex: 5,
            fit: FlexFit.tight,
            child: TextFormField(
              style: kFontStili(12),
              onEditingComplete: () async {
                await getUrunIdByBarcode();
                await getUrunById();
              },
              controller: barkodController,
              decoration: const InputDecoration(
                  labelText: "Barkod",
                  icon: Icon(Icons.qr_code_scanner_outlined)),
              validator: (val) {
                if (val!.isEmpty) {
                  return "Barkod Boş Bırakılamaz";
                } else {
                  return null;
                }
              },
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: scanBarcode,
              icon: const Icon(Icons.camera_alt_outlined),
              label: Text('Tara', style: kFontStili(12)),
              style: ElevatedButton.styleFrom(
                  primary: Colors.amber, onPrimary: Colors.black),
            ),
          )
        ],
      ),
    );
  }

  Widget buildUrunKodu() {
    return SizedBox(
      key: UniqueKey(),
      height: 60,
      child: FocusScope(
        onFocusChange: (value) async {
          if (!value) {
            try {
              await getUrunByCode();
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(snackBarKontrol);
            }
          }
        },
        child: TextFormField(
          onEditingComplete: () async {
            try {
              await getUrunByCode();
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(snackBarKontrol);
            }
          },
          decoration: const InputDecoration(
              labelText: "Ürün Kodu",
              icon: Icon(Icons.paste_rounded),
              border: InputBorder.none),
          controller: urunKoduController,
          style: kFontStili(16),
          validator: (val) {
            if (val!.isEmpty) {
              return "Ürün Kodu Boş Bırakılamaz";
            } else {
              return null;
            }
          },
        ),
      ),
    );
  }

  Widget buildUrunAdi() {
    return SizedBox(
      key: UniqueKey(),
      height: 60,
      // decoration: BoxDecorationSettings(),
      // color: Colors.orangeAccent,
      child: TextFormField(
        decoration: const InputDecoration(
            labelText: "Ürün Adı",
            icon: Icon(Icons.paste_rounded),
            border: InputBorder.none),
        controller: urunAdiController,
        readOnly: true,
        style: kFontStili(13),
        validator: (val) {
          if (val!.isEmpty) {
            return "Ürün Adı Boş Bırakılamaz";
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget buildBirimFiyati() {
    return SizedBox(
      key: UniqueKey(),
      height: 60,
      // decoration: BoxDecorationSettings(),
      child: TextFormField(
        decoration: const InputDecoration(
            labelText: "Birim Fiyatı",
            icon: Icon(Icons.money),
            hintText: "Birim Fiyat Giriniz."
            // border: InputBorder.none),
            ),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.deny(','),
        ],
        controller: birimFiyatController,
        style: kMetinStili,
        validator: (val) {
          if (val!.isEmpty) {
            return "Birim Fiyatı Boş Bırakılamaz";
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget buildPakettekiAdetSayisi() {
    return SizedBox(
      key: UniqueKey(),
      height: 40,
      child: TextFormField(
        controller: paketIciAdetController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: "Paket İçi Adet",
          // labelStyle: kMetinStili,
          icon: Icon(Icons.pages_sharp),
        ),
        style: kFontStili(12),
        validator: (val) {
          if (val!.isEmpty) {
            return "Adet Boş Bırakılamaz.";
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget buildPaketSayisi() {
    return SizedBox(
      key: UniqueKey(),
      height: 40,
      // decoration: BoxDecorationSettings(),
      child: TextFormField(
        // initialValue: '1',
        onChanged: (value) {
          // if (value == lastInputValue) {
          getPaketAdetleriToplami();
        },

        onEditingComplete: () {
          getPaketAdetleriToplami();
        },
        controller: paketSayisiController,
        // focusNode: _adetFocus,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.deny(','),
        ],
        decoration: const InputDecoration(
          labelText: "Paket Sayısı",
        ),
        style: kMetinStili,
        validator: (val) {
          if (val!.isEmpty) {
            return "Adet Boş Bırakılamaz.";
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget buildAdet() {
    return SizedBox(
      key: UniqueKey(),
      height: 60,
      // decoration: BoxDecorationSettings(),
      child: TextFormField(
        // initialValue: '1',
        controller: adetController,
        // focusNode: _adetFocus,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.deny(','),
        ],
        decoration: const InputDecoration(
          labelText: "Adeti Giriniz.",
          // labelStyle: kMetinStili,
          icon: Icon(Icons.calculate_rounded),
          hintText: "Sayı Giriniz.",
        ),
        style: kMetinStili,
        validator: (val) {
          if (val!.isEmpty) {
            return "Adet Boş Bırakılamaz.";
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget buildAddButton() {
    return SizedBox(
      key: UniqueKey(),
      height: 60,
      child: ButtonTheme(
        child: DefaultButton(
          text: "Ekle",
          press: () async {
            formKey.currentState!.save();

            // checkUrunOnAlinanSiparis(_urunId!);
            await checkUrunOnAlinanSiparis(context, _urunId!);
            if (checkUrunItBeAdded) {
              await checkMiktarlarArasiFark(context, _urunId!);
            }
            if (checkUrunItBeAdded) {
              _birimFiyat = double.parse(birimFiyatController.text);
              _miktar = int.parse(adetController.text);
              _kdvHaricTutar = _miktar! * _birimFiyat!;
              _kdvTutari = _miktar! * 0 / 100;

              var check = hazirlananSiparisDurum == true
                  ? hazirlananSiparisBilgileriList
                      .any((element) => element.urunId == _urunId)
                  : hazirlananSiparisBilgileriGetIdList
                      .any((element) => element.urunId == _urunId);
              if (!check) {
                HazirlananSiparisBilgileri hazirlananSiparisBilgileri =
                    HazirlananSiparisBilgileri(
                  urunId: _urunId!,
                  // hazirlananSiparisId: _faturaId!,
                  miktar: _miktar!,
                  birimFiyat: _birimFiyat!,
                  dovizliBirimFiyat: 0,
                  dovizTuru: 1,
                  kdvHaricTutar: _kdvHaricTutar!,
                  kdvOrani: 0,
                  kdvTutari: 0,
                  tutar: _kdvHaricTutar!,
                  urunAdi: urunAdiController.text,
                  urunKodu: urunKoduController.text,
                  // resim: resimData,
                  insert: true,
                );

                hazirlananSiparisDurum == true
                    ? hazirlananSiparisBilgileri.hazirlananSiparisId =
                        _faturaId!
                    : hazirlananSiparisBilgileri.hazirlananSiparisId =
                        hazirlananSiparisEdit.id;
                // Yeni veya Düzenleme işlemlerine göre ekleme satırı
                hazirlananSiparisDurum == true
                    ? hazirlananSiparisBilgileriList
                        .add(hazirlananSiparisBilgileri)
                    : hazirlananSiparisBilgileriGetIdList
                        .add(hazirlananSiparisBilgileri);
              } else {
                var entity = hazirlananSiparisDurum == true
                    ? hazirlananSiparisBilgileriList
                        .singleWhere((element) => element.urunId == _urunId)
                    : hazirlananSiparisBilgileriGetIdList
                        .singleWhere((element) => element.urunId == _urunId);
                entity.miktar += _miktar!;
                entity.ilaveEdilmis = entity.ilaveEdilmis != null
                    ? entity.ilaveEdilmis! + _miktar!
                    : _miktar;
                entity.update = true;
              }
              ScaffoldMessenger.of(context).showSnackBar(snackBarUrunEkle);
              (context as Element).reassemble();

              adetController.clear();
              urunAdiController.clear();
              urunKoduController.clear();
              barkodController.clear();
              birimFiyatController.clear();
              paketIciAdetController.clear();
              paketSayisiController.clear();
            }
            print("Fatura ID: $_faturaId");
          },
        ),
      ),
    );
  }

  Future scanBarcode() async {
    barkodController.text = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "İptal", false, ScanMode.DEFAULT);
    await getUrunIdByBarcode();
    await getUrunById();
  }

  Future getUrunIdByBarcode() async {
    await UrunApiService.fetchUrunIdByBarcode(barkodController.text)
        .then((response) {
      setState(() {
        dynamic list = json.decode(response.body);
        List data = list;
        // List data = list['data'];
        urunBarkodBilgileri =
            data.map((model) => UrunBarkodBilgileri.fromJson(model)).toList();
        for (var element in urunBarkodBilgileri) {
          _urunId = element.urunId!;
          print('urun Id:$_urunId');
        }
      });
    });
  }

  Future getUrunById() async {
    UrunApiService.fetchUrunById(_urunId).then((response) {
      setState(() {
        dynamic list = json.decode(response.body!);
        List data = list;
        // List data = list['data'];
        urun = data.map((model) => Urun.fromJson(model)).toList();
        for (var element in urun) {
          urunAdiController.text = element.urunAdi;
          birimFiyatController.text = element.fiyat.toString();
          urunKoduController.text = element.urunKodu;
          paketIciAdetController.text = element.paketIciAdet.toString();
          // resimData = element.resim;
        }
      });
    });
  }

  Future getUrunByCode() async {
    await UrunApiService.fetchUrunByCode(urunKoduController.text)
        .then((response) {
      setState(() {
        dynamic list = json.decode(response.body);
        List data = list;
        // List data = list['data'];
        urun = data.map((model) => Urun.fromJson(model)).toList();
        for (var element in urun) {
          urunAdiController.text = element.urunAdi;
          birimFiyatController.text = element.fiyat.toString();
          paketIciAdetController.text = element.paketIciAdet.toString();
          _urunId = element.id;
          // resimData = element.resim;
        }
      });
    });
  }

  Future checkUrunOnAlinanSiparis(BuildContext context, int id) async {
    var check =
        alinanSiparisBilgileriList.any((element) => element.urunId == id);
    if (!check) {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                'ÜRÜN SİPARİŞTE YOK',
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
              content: const Text('ÜRÜNÜ EKLEYEMEZSİNİZ!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'İPTAL');
                    checkUrunItBeAdded = false;
                  },
                  child: const Text('İPTAL'),
                ),
                // TextButton(
                //   onPressed: () {
                //     Navigator.pop(context, 'EVET');
                //     checkUrunItBeAdded = true;
                //   },
                //   child: const Text('EVET'),
                // ),
              ],
            );
          });
    } else {
      checkUrunItBeAdded = true;
    }
  }

  checkMiktarlarArasiFark(BuildContext context, int id) async {
    int howManyProduct = alinanSiparisBilgileriList
        .where((element) => element.urunId == id)
        .length;

    if (howManyProduct > 1) {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                'BİRDEN FAZLA SİPARİŞ VAR!',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.orange),
              ),
              content: const Text(
                'BU ÜRÜNDEN BİRDEN FAZLA SİPARİŞ OLDUĞU İÇİN KONTROLÜ SAĞLANAMIYOR!',
                style: TextStyle(color: Colors.black),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'TAMAM');
                  },
                  child: const Text('TAMAM'),
                ),
              ],
            );
          });
      checkUrunItBeAdded = false;
      return;
    }

    var check = alinanSiparisBilgileriList
        .singleWhere((element) => element.urunId == id);
    // : alinanSiparisBilgileriList.singleWhere((element) =>
    //     element.urunId == id && element.kalanMiktar == null
    //         ? element.miktar == int.parse(miktarController.text)
    //         : element.kalanMiktar == int.parse(miktarController.text));
    int olmasiGerekenMiktar =
        check.kalanMiktar == null ? check.miktar : check.kalanMiktar!;
    //check.miktar - (check.miktar-check.kalanMiktar!);
    int fark = check.kalanMiktar == null
        ? check.miktar - int.parse(adetController.text)
        : check.kalanMiktar! - int.parse(adetController.text);
    kalanMiktarDegistir() {
      check.kalanMiktar = fark;
    }

    if (fark != 0) {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                'ÜRÜN ADEDİ UYUŞMUYOR!',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.orange),
              ),
              content: Text(
                'OLMASI GEREKEN MİKTAR: $olmasiGerekenMiktar \n${fark > 0 ? 'EKSİK MİKTAR: $fark' : 'ARTAN MİKTAR: ${fark * -1}'} \n\nYİNE DE DEĞİŞİKLİK YAPMADAN EKLEMEK İSTER MİSİNİZ?',
                style: TextStyle(color: fark > 0 ? Colors.purple : Colors.red),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'HAYIR');
                    checkUrunItBeAdded = false;
                  },
                  child: const Text('HAYIR'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'EVET');
                    checkUrunItBeAdded = true;
                    kalanMiktarDegistir();
                  },
                  child: const Text('EVET'),
                ),
              ],
            );
          });
    } else {
      kalanMiktarDegistir();
    }
  }

  getPaketAdetleriToplami() {
    paketSayisiController.text != ""
        ? adetController.text = (int.parse(paketIciAdetController.text) *
                int.parse(paketSayisiController.text))
            .toString()
        : adetController.text = "0";
  }

  BoxDecoration boxDecorationSettings() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(10), color: Colors.green[200]);
  }
}
