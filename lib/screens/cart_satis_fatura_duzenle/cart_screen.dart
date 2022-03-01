import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stoktakip_app/const/text_const.dart';
import 'package:stoktakip_app/model/satis_fatura/satis_fatura_duzenle.dart';
import 'package:stoktakip_app/model/satis_fatura/urun_bilgileri.dart';
import 'package:stoktakip_app/screens/shared_settings/settings_page.dart';
// import 'package:shop_app/models/Cart.dart';

import 'components/body.dart';
import 'components/check_out_card.dart';

class CartScreenSatisFaturaDuzenle extends StatelessWidget {
  static String routeName = "/cartsatisfaturaduzenle";

  const CartScreenSatisFaturaDuzenle({Key? key}) : super(key: key);
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
            "Sepet -(${satisFaturaDuzenle.cariHesapAdi})",
            style: const TextStyle(color: Colors.black),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "${urunBilgileriGetIdList.length} ürün",
                  style: Theme.of(context).textTheme.caption,
                ),
                TextSpan(
                    text: '  Sepeti Temizle',
                    style: linkStyle,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        urunBilgileriGetIdList.clear();
                        Navigator.of(context).pop(true);
                      }),
              ],
            ),
          )
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.pushNamed(context, SettingsPage.routeName);
          },
        ),
      ],
    );
  }
}
