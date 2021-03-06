import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stoktakip_app/const/text_const.dart';
import 'package:stoktakip_app/functions/const_entities.dart';
import 'package:stoktakip_app/model/verilen_siparis/verilen_siparis_bilgileri.dart';
// import 'package:shop_app/models/Cart.dart';

import 'components/body.dart';
import 'components/check_out_card.dart';

class CartScreenGelenSiparis extends StatelessWidget {
  static String routeName = "/cart-gelen-siparis";

  const CartScreenGelenSiparis({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: const Body(),
      bottomNavigationBar: const CheckoutCard(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Column(
        children: [
          Text(
            "Sepet -(${gelenSiparisDurum == true ? gelenSiparisSingle.siparisAdi : gelenSiparisEdit.siparisAdi})",
            style: const TextStyle(color: Colors.black),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text:
                      "${gelenSiparisDurum == true ? gelenSiparisBilgileriList.length : gelenSiparisBilgileriGetIdList.length} ürün",
                  style: Theme.of(context).textTheme.caption,
                ),
                TextSpan(
                    text: '  Sepeti Temizle',
                    style: linkStyle,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        silmeOnay(context);
                      }),
              ],
            ),
          )
        ],
      ),
    );
  }

  silmeOnay(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'SEPETİ TEMİZLE!',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
            ),
            content: const Text(
              'SEPETİ TEMİZLEMEK İSTEDİĞİNİZE EMİN MİSİNİZ?!',
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'HAYIR');
                },
                child: const Text('HAYIR'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'EVET');
                  gelenSiparisBilgileriList.clear();
                  Navigator.of(context).pop(true);
                  dynamic list =
                      json.decode(verilenSiparisBilgileriControlString!);
                  List data = list;
                  // List data = list['data'];
                  verilenSiparisBilgileriList = data
                      .map((model) => VerilenSiparisBilgileri.fromJson(model))
                      .cast<VerilenSiparisBilgileri>()
                      .toList();
                },
                child: const Text('EVET'),
              ),
            ],
          );
        });
  }
}
