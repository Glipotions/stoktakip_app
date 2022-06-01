import 'package:flutter/material.dart';
import 'package:stoktakip_app/const/text_const.dart';
import 'package:stoktakip_app/model/cari_hesap/cari_hesap.dart';
import 'package:stoktakip_app/model/gelen_urun_siparis/gelen_siparis.dart';
import 'package:stoktakip_app/size_config.dart';

class ListCard extends StatelessWidget {
  ListCard({Key? key, required this.cart}) : super(key: key);

  GelenSiparis cart;
  CariHesap cari = CariHesap(firma: null, bakiye: 0, id: -1);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          // DateFormat.yMMMd('tr').format(cart.tarih),
          cart.tarih!.toString(),
          style: kFontStili(12),
          maxLines: 2,
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.only(right: getProportionateScreenWidth(30)),
            child: Text(
              "${cart.siparisAdi}",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ),
      ],
    );
  }
}
