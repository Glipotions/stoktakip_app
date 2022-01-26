import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stoktakip_app/components/default_button.dart';
import 'package:stoktakip_app/const/text_const.dart';
import 'package:stoktakip_app/functions/const_functions.dart';
import 'package:stoktakip_app/functions/general_functions.dart';
import 'package:stoktakip_app/model/satis_fatura.dart';
import 'package:stoktakip_app/model/urun.dart';
import 'package:stoktakip_app/model/urun_barkod_bilgileri.dart';
import 'package:stoktakip_app/model/urun_bilgileri.dart';
import 'package:stoktakip_app/model/urun_bilgileri_satin_alma.dart';
import 'package:stoktakip_app/screens/cart_satin_alma_fatura/cart_screen.dart';
import 'package:stoktakip_app/screens/cart_satis_fatura/cart_screen.dart';
import 'package:stoktakip_app/screens/urun_bilgileri/components/check_out_card.dart';
import 'package:stoktakip_app/services/api.services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:stoktakip_app/size_config.dart';

class UrunBilgileriAdd extends StatefulWidget {
  static String routeName = "/urun-bilgileri-add";

  List<SatisFatura>? satisFaturas;
  UrunBilgileriAdd({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UrunBilgileriAddState();
  }
}

class _UrunBilgileriAddState extends State<UrunBilgileriAdd> {
  final snackBar = const SnackBar(content: Text('Ürün Sepete Eklendi!'));
  var formKey = GlobalKey<FormState>();
  var barkodController = TextEditingController(),
      kdvHaricTutarController = TextEditingController(),
      urunKoduController = TextEditingController(),
      urunAdiController = TextEditingController(),
      birimFiyatController = TextEditingController(),
      miktarController = TextEditingController(),
      adetController = TextEditingController();
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
    super.dispose();
  }

  // List<UrunBilgileri> urunBilgileriList = [];
  var urunBarkodBilgileri = <UrunBarkodBilgileri>[];
  var urun = <Urun>[];
  int? _urunId, _miktar, _tutar, _faturaId = buildId();
  double? _birimFiyat, _kdvHaricTutar, _kdvTutari;
  // int kdvHaricTutar = _miktar * _birimFiyat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sepete Ürün Ekle",
          style: kMetinStili,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => CartScreen(),
              //   ),
              // );
              faturaDurum!
                  ? Navigator.pushNamed(
                      context, CartScreenSatisFatura.routeName)
                  : Navigator.pushNamed(
                      context, CartScreenSatinAlmaFatura.routeName);
            },
          ),
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
      // decoration: BoxDecorationSettings(),
      // color: Colors.orangeAccent,
      child: FocusScope(
        onFocusChange: (value) async {
          if (!value) {
            await getUrunByCode();
          }
        },
        child: TextFormField(
          onEditingComplete: () async {
            await getUrunByCode();
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
            border: InputBorder.none),
        controller: birimFiyatController,
        focusNode: _adetFocus,
        readOnly: true,
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

  Widget buildAdet() {
    return SizedBox(
      key: UniqueKey(),
      height: 60,
      // decoration: BoxDecorationSettings(),
      child: TextFormField(
        // initialValue: '1',
        controller: adetController,
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

  // Widget buildKdvHaricToplamTutar() {
  //   return Expanded(
  //           key: UniqueKey(),
  //     child: TextFormField(
  //       controller: kdvHaricTutarController,
  //       keyboardType: TextInputType.number,
  //       inputFormatters: [
  //         FilteringTextInputFormatter.deny(','),
  //       ],
  //       decoration: const InputDecoration(
  //           labelText: "Kdv Hariç Toplam Tutar", hintText: "Sayı Giriniz."),
  //     ),
  //   );
  // }

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
            _kdvTutari = _miktar! * 0 / 100;

            if (faturaDurum!) {
              UrunBilgileri urunBilgileri = UrunBilgileri(
                  urunId: _urunId!,
                  // satisFaturaId: 1,
                  satisFaturaId: _faturaId!,
                  birimFiyat: _birimFiyat!,
                  kdvHaricTutar: _kdvHaricTutar!,
                  miktar: _miktar!,
                  dovizliBirimFiyat: 0,
                  kdvOrani: 0,
                  tutar: _kdvHaricTutar! + _kdvTutari!,
                  kdvTutari: 0,
                  urunAdi: urunAdiController.text,
                  urunKodu: urunKoduController.text);
              urunBilgileriList.add(urunBilgileri);
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

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            (context as Element).reassemble();
            adetController.clear();
            urunAdiController.clear();
            urunKoduController.clear();
            barkodController.clear();
            birimFiyatController.clear();
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
          for (int i = 0; i < urunBilgileriList.length; i++) {
            APIServices.postUrunBilgileri(urunBilgileriList[i]);
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
    await APIServices.fetchUrunIdByBarcode(barkodController.text)
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
    APIServices.fetchUrunById(_urunId).then((response) {
      setState(() {
        dynamic list = json.decode(response.body!);
        List data = list;
        // List data = list['data'];
        urun = data.map((model) => Urun.fromJson(model)).toList();
        for (var element in urun) {
          urunAdiController.text = element.urunAdi;
          birimFiyatController.text = element.fiyat.toString();
          urunKoduController.text = element.urunKodu;
        }
      });
    });
  }

  Future getUrunByCode() async {
    await APIServices.fetchUrunByCode(urunKoduController.text).then((response) {
      setState(() {
        dynamic list = json.decode(response.body);
        List data = list;
        // List data = list['data'];
        urun = data.map((model) => Urun.fromJson(model)).toList();
        for (var element in urun) {
          urunAdiController.text = element.urunAdi;
          birimFiyatController.text = element.fiyat.toString();
          _urunId = element.id;
        }
      });
    });
  }

  BoxDecoration boxDecorationSettings() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(10), color: Colors.green[200]);
  }
}
