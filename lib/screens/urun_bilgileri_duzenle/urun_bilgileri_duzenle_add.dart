// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stoktakip_app/components/default_button.dart';
import 'package:stoktakip_app/const/text_const.dart';
import 'package:stoktakip_app/functions/const_entities.dart';
import 'package:stoktakip_app/functions/general_functions.dart';
import 'package:stoktakip_app/functions/will_pop_scope_back_function.dart';
import 'package:stoktakip_app/model/satis_fatura/satis_fatura.dart';
import 'package:stoktakip_app/model/satis_fatura/satis_fatura_duzenle.dart';
import 'package:stoktakip_app/model/urun/urun.dart';
import 'package:stoktakip_app/model/urun/urun_barkod_bilgileri.dart';
import 'package:stoktakip_app/model/satis_fatura/urun_bilgileri.dart';
import 'package:stoktakip_app/model/satin_alma/urun_bilgileri_satin_alma.dart';
import 'package:stoktakip_app/screens/cart_satin_alma_fatura/cart_screen.dart';
import 'package:stoktakip_app/screens/cart_satis_fatura_duzenle/cart_screen.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:stoktakip_app/services/api_services/urun_api_service.dart';
import 'package:stoktakip_app/services/api_services/urun_bilgileri_api_service.dart';
import 'package:stoktakip_app/size_config.dart';

import 'components/check_out_card.dart';

class UrunBilgileriDuzenleAdd extends StatefulWidget {
  static String routeName = "/urun-bilgileri-duzenle-add";

  List<SatisFatura>? satisFaturas;
  UrunBilgileriDuzenleAdd({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UrunBilgileriDuzenleAddState();
  }
}

class _UrunBilgileriDuzenleAddState extends State<UrunBilgileriDuzenleAdd> {
  final snackBarUrunEkle =
      const SnackBar(content: Text("Ürün Başarıyla Eklendi."));
  final snackBarKontrol = const SnackBar(content: Text("Ürün Bulunamadı."));

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

  // List<UrunBilgileri> urunBilgileriGetIdList = [];
  var urunBarkodBilgileri = <UrunBarkodBilgileri>[];
  var urun = <Urun>[];
  int? _urunId, _miktar, _tutar, _faturaId = buildId();
  double? _birimFiyat, _kdvHaricTutar, _kdvTutari, _kdvOrani;

  // int kdvHaricTutar = _miktar * _birimFiyat;

  @override
  Widget build(BuildContext context) {
    _kdvOrani = satisFaturaDuzenle.satisFaturaKdvOrani != 0
        ? satisFaturaDuzenle.satisFaturaKdvOrani!
        : 0;
    return WillPopScope(
      onWillPop: () async {
        bool? result =
            await onBackPressedCancelFatura(context, "Fatura düzenlemesi");
        result ??= false;
        return result;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Sepete Ürün Ekle",
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
                      faturaDurum!
                          ? Navigator.pushNamed(
                              context, CartScreenSatisFaturaDuzenle.routeName)
                          : Navigator.pushNamed(
                              context, CartScreenSatinAlmaFatura.routeName);
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
                        urunBilgileriGetIdList.isEmpty
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
                                          urunBilgileriGetIdList.length
                                              .toString(),
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
        body: Container(
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
                buildBirimFiyati(),
                SizedBox(height: getProportionateScreenHeight(10)),
                Row(
                  children: <Widget>[
                    Expanded(child: buildPakettekiAdetSayisi()),
                    Expanded(child: buildPaketSayisi()),
                  ],
                ),
                // buildPaketSayisi(),
                // SizedBox(height: getProportionateScreenHeight(5)),
                // buildPaketSayisi(),
                SizedBox(height: getProportionateScreenHeight(10)),
                buildAdet(),
                // buildKdvHaricToplamTutar(),
                SizedBox(height: getProportionateScreenHeight(10)),
                buildAddButton(),
                // buildSaveButton()
              ],
            ),
          ),
        ),
        bottomNavigationBar: CheckoutCard(),
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
      // decoration: BoxDecorationSettings(),
      child: TextFormField(
        // initialValue: '1',
        controller: paketIciAdetController,
        // focusNode: _adetFocus,
        keyboardType: TextInputType.number,
        // readOnly: true,
        // inputFormatters: [
        //   FilteringTextInputFormatter.deny(','),
        // ],
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
          // labelStyle: kMetinStili,
          // icon: Icon(Icons.pages_sharp),
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
          press: () {
            formKey.currentState!.save();

            _birimFiyat = double.parse(birimFiyatController.text);
            _miktar = int.parse(adetController.text);
            _kdvHaricTutar = _miktar! * _birimFiyat!;
            _kdvTutari = _miktar! * _kdvOrani! / 100;

            if (faturaDurum!) {
              UrunBilgileri urunBilgileri = UrunBilgileri(
                urunId: _urunId!,
                // satisFaturaId: 1,
                satisFaturaId: satisFaturaDuzenle.satisFaturaId!,
                birimFiyat: _birimFiyat!,
                kdvHaricTutar: _kdvHaricTutar!,
                miktar: _miktar!,
                dovizliBirimFiyat: 0,
                kdvOrani: _kdvOrani!,
                tutar: _kdvHaricTutar! + _kdvTutari!,
                kdvTutari: _kdvTutari!,
                urunAdi: urunAdiController.text,
                urunKodu: urunKoduController.text,
                insert: true,
              );
              urunBilgileriGetIdList.add(urunBilgileri);
            } else if (!faturaDurum!) {
              UrunBilgileriSatinAlma urunBilgileriSatinAlma =
                  UrunBilgileriSatinAlma(
                      urunId: _urunId!,
                      satinAlmaFaturaId: _faturaId!,
                      birimFiyat: _birimFiyat!,
                      kdvHaricTutar: _kdvHaricTutar!,
                      miktar: _miktar!,
                      dovizliBirimFiyat: 0,
                      kdvOrani: 0,
                      tutar: _kdvHaricTutar! + _kdvTutari!,
                      kdvTutari: 0,
                      urunAdi: urunAdiController.text,
                      urunKodu: urunKoduController.text);
              urunBilgileriSatinAlmaList.add(urunBilgileriSatinAlma);
            }

            print("Fatura ID: $_faturaId");

            ScaffoldMessenger.of(context).showSnackBar(snackBarUrunEkle);
            (context as Element).reassemble();
            adetController.clear();
            urunAdiController.clear();
            urunKoduController.clear();
            barkodController.clear();
            birimFiyatController.clear();
            paketIciAdetController.clear();
            paketSayisiController.clear();
          },
        ),
      ),
    );
  }

  Widget buildSaveButton() {
    return Expanded(
      child: ElevatedButton(
        child: const Text("Kaydet"),
        onPressed: () {
          // urunBilgileri.id = buildId();
          formKey.currentState!.save(); //elimizdeki student oluştu
          // widget.satisFaturas!.add(satisFatura); //ekleme işlemini yapar.
          for (int i = 0; i < urunBilgileriGetIdList.length; i++) {
            UrunBilgileriApiService.postUrunBilgileri(
                urunBilgileriGetIdList[i]);
          }
        },
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
        }
      });
    });
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
