// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:stoktakip_app/change_notifier_model/kasa_data.dart';
import 'package:stoktakip_app/const/constants.dart';
import 'package:stoktakip_app/const/text_const.dart';
import 'package:stoktakip_app/functions/const_entities.dart';
import 'package:stoktakip_app/change_notifier_model/kdv_data.dart';
import 'package:stoktakip_app/model/kasa/kasa.dart';
import 'package:stoktakip_app/services/api.services.dart';

import '../../size_config.dart';

class SettingsPage extends StatelessWidget {
  static String routeName = "/settings-page";

  const SettingsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Ayarlar'),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: const SwitchCard());
  }
}

class SwitchCard extends StatefulWidget {
  const SwitchCard({Key? key}) : super(key: key);

  @override
  State<SwitchCard> createState() => _SwitchCardState();
}

class _SwitchCardState extends State<SwitchCard> {
  List<Kasa> kasa = <Kasa>[];
  Object? dropDownMenu;
  var kasaList = <Kasa>[];

  Future<List> _getKasas() async {
    await APIServices.fetchKasa().then((response) {
      setState(() {
        dynamic list = json.decode(response.body);
        List data = list;
        kasa = data.map((model) => Kasa.fromJson(model)).toList();
      });
    });
    return kasa;
  }

  Future getKasaById() async {
    await APIServices.fetchKasaById(kasaEntity.id).then((response) {
      setState(() {
        dynamic list = json.decode(response.body);
        List data = list;
        // List data = list['data'];
        kasaList =
            data.map((model) => Kasa.fromJson(model)).cast<Kasa>().toList();
        for (var element in kasaList) {
          kasaEntity.id = element.id;
          kasaEntity.bakiye = element.bakiye;
          kasaEntity.kasaAdi = element.kasaAdi;
        }
        print(kasaEntity.bakiye);
        print(kasaEntity.id);
      });
    });
  }

  Future<void> initStateAsync() async {
    await _getKasas();
  }

  @override
  void initState() {
    initStateAsync();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int? _kasaId = Provider.of<KasaData>(context).kasaId;
    double _value = Provider.of<KdvData>(context).kdv;

    String _kasaAdi = Provider.of<KasaData>(context).kasaAdi!;
    double _currentSliderValue = _value.toDouble();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Colors.orange[300],
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    bottomRight: Radius.circular(20.0))),
            // color: Colors.amber[200],
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Kdv"),
                ),
                SizedBox(width: getProportionateScreenWidth(10)),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: kTextColor,
                ),
                Slider(
                  value: _value.toDouble(),
                  min: 0,
                  max: 30,
                  divisions: 30,
                  label: "Kdv Oranı: ${_value.toString()}",
                  onChanged: (double value) {
                    setState(() {
                      _currentSliderValue = value;
                      Provider.of<KdvData>(context, listen: false)
                          .kdvSec(value.toDouble());
                    });
                  },
                ),
                Text("Oran: ${_currentSliderValue.round().toString()}",
                    style: kMetinStili),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.orange[300],
              shape: BoxShape.rectangle,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            child: DropdownButton(
              alignment: Alignment.center,
              hint: const Text('Varsayılan Kasa Seçiniz'),
              value: _kasaId,
              items: kasa.map((kasaM) {
                return DropdownMenuItem(
                  value: kasaM.id,
                  child: Text(kasaM.kasaAdi.toString()),
                  onTap: () {
                    kasaEntity.bakiye = kasaM.bakiye;
                    kasaEntity.kasaAdi = kasaM.kasaAdi;
                    Provider.of<KasaData>(context, listen: false)
                        .kasaSec(kasaM.id, kasaM.kasaAdi!);
                  },
                );
              }).toList(),
              onChanged: (newValue) async {
                setState(() {
                  dropDownMenu = newValue;
                  kasaEntity.id = int.parse(dropDownMenu.toString());
                  // await fetchCariHesapById(int.parse(dropDownMenu.toString()));
                });
                // await getKasaById();
                print(kasaEntity.kasaAdi);
              },
            ),
          ),
        ),
      ],
    );
  }
}
