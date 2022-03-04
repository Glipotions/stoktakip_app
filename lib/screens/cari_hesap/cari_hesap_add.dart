// ignore_for_file: avoid_print

import 'dart:core';
import 'package:flutter/material.dart';
import 'package:stoktakip_app/functions/general_functions.dart';
import 'package:stoktakip_app/model/cari_hesap/cari_hesap.dart';
import 'package:stoktakip_app/services/api_services/cari_hesap_api_service.dart';

class AddCariHesap extends StatefulWidget {
  const AddCariHesap({Key? key}) : super(key: key);

  @override
  _AddCariHesapState createState() => _AddCariHesapState();
}

class _AddCariHesapState extends State<AddCariHesap> {
  final _formKey = GlobalKey<FormState>();
  var kodController = TextEditingController();
  var firmaController = TextEditingController();
  var bakiyeController = TextEditingController();
  var aciklamaController = TextEditingController();
  var sehirController = TextEditingController();
  final int _id = buildId();

  @override
  void dispose() {
    kodController.dispose();
    firmaController.dispose();
    bakiyeController.dispose();
    aciklamaController.dispose();
    sehirController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add CariHesap"),
      ),
      body: _buildForm(),
    );
  }

  Widget _buildForm() {
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: kodController,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Kod Boş Bırakılamaz";
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(
                    labelText: 'Kod Giriniz.',
                    icon: Icon(Icons.account_tree_rounded)),
              ),
              TextFormField(
                controller: firmaController,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Firma Boş Bırakılamaz.";
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(
                    labelText: 'Firma Adı Giriniz.',
                    icon: Icon(Icons.add_chart)),
              ),
              TextFormField(
                controller: bakiyeController,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Bakiye boş bırakılamaz";
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(
                    labelText: 'Bakiye Giriniz.', icon: Icon(Icons.money)),
              ),
              TextFormField(
                controller: sehirController,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Şehir boş bırakılamaz";
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(
                    labelText: 'Şehir Giriniz.', icon: Icon(Icons.money)),
              ),
              TextFormField(
                controller: aciklamaController,
                decoration: const InputDecoration(
                    labelText: 'Açıklama Giriniz.', icon: Icon(Icons.comment)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 25.0, horizontal: 25.0),
                child: ElevatedButton.icon(
                  label: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: const Icon(
                    Icons.save,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      CariHesap student = CariHesap(
                          id: buildId(),
                          kod: kodController.text,
                          firma: firmaController.text,
                          bakiye: double.parse(bakiyeController.text),
                          aciklama: aciklamaController.text,
                          sehir: sehirController.text,
                          durum: true);
                      var tes = CariHesapApiService.postCariHesap(student);
                      print(tes);
                    }
                  },
                ),
              ),
              FloatingActionButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    CariHesap cariHesap = CariHesap(
                        id: _id,
                        kod: kodController.text,
                        firma: firmaController.text,
                        bakiye: double.parse(bakiyeController.text),
                        aciklama: aciklamaController.text,
                        sehir: sehirController.text,
                        durum: true,
                        email: 'd@d.com',
                        faks: 'd@d.com',
                        tcKimlikNo: '546484',
                        telefon1: '954876458',
                        telefon2: '484787999',
                        vergiDairesi: 'dentis',
                        vergiNo: 'r9');
                    var tes = CariHesapApiService.postCariHesap(cariHesap);
                    print(tes);
                    print(_id);
                  }
                },
                backgroundColor: Colors.amberAccent,
              ),
            ],
          ),
        ));
  }
}
