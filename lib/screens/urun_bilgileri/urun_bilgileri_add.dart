import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stoktakip_app/components/default_button.dart';
import 'package:stoktakip_app/const/text_const.dart';
import 'package:stoktakip_app/functions/general_functions.dart';
import 'package:stoktakip_app/model/satis_fatura.dart';
import 'package:stoktakip_app/model/urun.dart';
import 'package:stoktakip_app/model/urun_barkod_bilgileri.dart';
import 'package:stoktakip_app/model/urun_bilgileri.dart';
import 'package:stoktakip_app/screens/cart/cart_screen.dart';
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
      urunAdiController = TextEditingController(),
      birimFiyatController = TextEditingController(),
      miktarController = TextEditingController(),
      adetController = TextEditingController();

  @override
  void dispose() {
    barkodController.dispose();
    kdvHaricTutarController.dispose();
    urunAdiController.dispose();
    birimFiyatController.dispose();
    miktarController.dispose();
    adetController.dispose();
    super.dispose();
  }

  // List<UrunBilgileri> urunBilgileriList = [];
  var urunBarkodBilgileri = <UrunBarkodBilgileri>[];
  var urun = <Urun>[];
  int? _urunId, _miktar, _tutar, _satisFaturaId = buildId();
  double? _birimFiyat, _kdvHaricTutar, _kdvTutari;
  // int kdvHaricTutar = _miktar * _birimFiyat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ürün Ekle",
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
              Navigator.pushNamed(context, CartScreen.routeName);
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
              buildUrunAdi(),
              SizedBox(height: getProportionateScreenHeight(10)),
              buildBirimAdedi(),
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
    return Container(
      key: UniqueKey(),
      height: 60,
      // decoration: BoxDecorationSettings(),
      child: Row(
        children: [
          Flexible(
            flex: 6,
            fit: FlexFit.tight,
            child: TextFormField(
              style: kMetinStili,
              onEditingComplete: () async {
                await getUrunIdByBarcode();
                await getUrunById();
              },
              controller: barkodController,
              decoration: const InputDecoration(
                  labelText: "Barkod Okutunuz.",
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
              label: const Text('Tara'),
              style: ElevatedButton.styleFrom(
                  primary: Colors.amber, onPrimary: Colors.black),
            ),
          )
        ],
      ),
    );
  }

  Widget buildUrunAdi() {
    return Container(
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
        style: kMetinStili,
      ),
    );
  }

  Widget buildBirimAdedi() {
    return Container(
      key: UniqueKey(),
      height: 60,
      // decoration: BoxDecorationSettings(),
      child: TextFormField(
        decoration: const InputDecoration(
            labelText: "Birim Fiyatı",
            icon: Icon(Icons.money),
            border: InputBorder.none),
        controller: birimFiyatController,
        readOnly: true,
        style: kMetinStili,
      ),
    );
  }

  Widget buildAdet() {
    return Container(
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
    return Container(
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
            UrunBilgileri urunBilgileri = UrunBilgileri(
                urunId: _urunId!,
                // satisFaturaId: 1,
                satisFaturaId: _satisFaturaId!,
                kdvHaricTutar: _kdvHaricTutar!,
                miktar: _miktar!,
                dovizliBirimFiyat: _birimFiyat != null ? _birimFiyat! : 1,
                kdvOrani: 0,
                tutar: _kdvHaricTutar! + _kdvTutari!,
                kdvTutari: 0,
                urunAdi: urunAdiController.text);
            print("Satış Fatura ID: ${_satisFaturaId}");
            urunBilgileriList.add(urunBilgileri);
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            (context as Element).reassemble();
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
    getUrunIdByBarcode();
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
          print('Get ürün by id döngü');
        }
      });
    });
  }

  BoxDecoration BoxDecorationSettings() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(10), color: Colors.green[200]);
  }
}
