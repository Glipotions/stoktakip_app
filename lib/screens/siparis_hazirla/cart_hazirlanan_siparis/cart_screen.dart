import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stoktakip_app/const/text_const.dart';
import 'package:stoktakip_app/functions/const_entities.dart';
import 'package:stoktakip_app/model/cari_hesap/cari_hesap.dart';
import 'package:stoktakip_app/screens/shared_settings/settings_page.dart';
// import 'package:shop_app/models/Cart.dart';

import 'components/body.dart';
import 'components/check_out_card.dart';

class CartScreenHazirlananSiparis extends StatelessWidget {
  static String routeName = "/cart-hazirlanan-siparis";

  const CartScreenHazirlananSiparis({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: const Body(),
      bottomNavigationBar: CheckoutCard(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Column(
        children: [
          Text(
            "Sepet -(${hazirlananSiparisDurum == true ? hazirlananSiparisSingle.siparisAdi : hazirlananSiparisEdit.siparisAdi})",
            style: const TextStyle(color: Colors.black),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text:
                      "${hazirlananSiparisDurum == true ? hazirlananSiparisBilgileriList.length : hazirlananSiparisBilgileriGetIdList.length} ürün",
                  style: Theme.of(context).textTheme.caption,
                ),
                TextSpan(
                    text: '  Sepeti Temizle',
                    style: linkStyle,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        hazirlananSiparisBilgileriList.clear();
                        Navigator.of(context).pop(true);
                      }),
              ],
            ),
          )
        ],
      ),
      // actions: [
      //   IconButton(
      //     icon: const Icon(Icons.search),
      //     onPressed: () {
      //       // Navigator.pushNamed(context, SettingsPage.routeName);
      //     },
      //   ),
      // ],
    );
  }
}