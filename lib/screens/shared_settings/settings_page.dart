import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:stoktakip_app/const/constants.dart';
import 'package:stoktakip_app/const/text_const.dart';
import 'package:stoktakip_app/model/kdv_data.dart';

import '../../size_config.dart';

class SettingsPage extends StatelessWidget {
  static String routeName = "/settings-page";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Ayarlar'),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SwitchCard());
  }
}

class SwitchCard extends StatefulWidget {
  @override
  State<SwitchCard> createState() => _SwitchCardState();
}

class _SwitchCardState extends State<SwitchCard> {
  @override
  Widget build(BuildContext context) {
    int _value = Provider.of<KdvData>(context).kdv;
    double _currentSliderValue = _value.toDouble();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Colors.orange[300],
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    bottomRight: Radius.circular(25.0))),
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
                          .kdvSec(value.toInt());
                    });
                  },
                ),
                Text("Oran: ${_currentSliderValue.round().toString()}",
                    style: kSayiStili),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
