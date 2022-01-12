import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stoktakip_app/model/satis_fatura.dart';
import 'package:stoktakip_app/services/api.services.dart';
import '../functions/general_functions.dart';

class SatisFaturaAdd extends StatefulWidget {
  List<SatisFatura>? satisFaturas;
  SatisFaturaAdd({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SatisFaturaAddState();
  }
}

class _SatisFaturaAddState extends State<SatisFaturaAdd> {
  var formKey = GlobalKey<FormState>();
  var kodController = TextEditingController(),
      cariHesapController = TextEditingController(),
      toplamTutarController = TextEditingController();

  @override
  void dispose() {
    kodController.dispose();
    cariHesapController.dispose();
    toplamTutarController.dispose();
    super.dispose();
  }

  SatisFatura satisFatura = SatisFatura(
      id: 0,
      // kod: "kod",
      cariHesapId: 1,
      faturaTuru: 3,
      dovizTuru: 1,
      tarih: DateTime.now(),
      kdvSekli: 1,
      kdvHaricTutar: 0,
      iskontoTutari: 0,
      kdvTutari: 0,
      toplamTutar: 0,
      dovizTutar: 0,
      iskontoOrani: 0,
      dovizKuru: 1,
      durum: true,
      ozelKod1Id: null,
      odemeTipi: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Satış Faturası"),
        ),
        body: Container(
          margin: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                // buildIdBuild(),
                buildKodBuild(),
                buildCariHesapIdBuild(),
                buildToplamTutarBuild(),
                buildSaveButton()
              ],
            ),
          ),
        ));
  }

  Widget buildKodBuild() {
    return TextFormField(
      controller: kodController,
      decoration: const InputDecoration(
          labelText: "Kod Giriniz.",
          hintText: "000000X",
          icon: Icon(Icons.account_tree_rounded)),
      onSaved: (String? value) {
        // satisFatura.kod = value!;
      },
      validator: (val) {
        if (val!.isEmpty) {
          return "Kod Boş Bırakılamaz";
        } else {
          return null;
        }
      },
    );
  }

  Widget buildCariHesapIdBuild() {
    return TextFormField(
      decoration: const InputDecoration(
          labelText: "CariHesapId Giriniz.", hintText: "Sayı Giriniz."),
      onSaved: (String? value) {
        satisFatura.cariHesapId = int.parse(value!);
      },
      validator: (val) {
        if (val!.isEmpty) {
          return "Cari Hesap Boş Bırakılamaz.";
        } else {
          return null;
        }
      },
    );
  }

  Widget buildToplamTutarBuild() {
    return TextFormField(
      controller: toplamTutarController,
      decoration: const InputDecoration(
          labelText: "Toplam Tutar", hintText: "Sayı Giriniz."),
      onSaved: (String? value) {
        satisFatura.toplamTutar = double.parse(value!);
      },
    );
  }

  Widget buildSaveButton() {
    return ElevatedButton(
      child: const Text("Kaydet"),
      onPressed: () {
        satisFatura.id = buildId();
        formKey.currentState!.save(); //elimizdeki student oluştu
        // widget.satisFaturas!.add(satisFatura); //ekleme işlemini yapar.
        APIServices.postSatisFatura(satisFatura);
        // Navigator.pop(context); // Önceki sayfaya otomatik olarak döner
      },
    );
  }
}
