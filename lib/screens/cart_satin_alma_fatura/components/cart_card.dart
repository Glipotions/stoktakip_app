import 'package:flutter/material.dart';
import 'package:stoktakip_app/const/constants.dart';
import 'package:stoktakip_app/const/text_const.dart';
import 'package:stoktakip_app/model/urun/urun.dart';
import 'package:stoktakip_app/model/satin_alma/urun_bilgileri_satin_alma.dart';
import 'package:stoktakip_app/size_config.dart';

class CartCard extends StatelessWidget {
  CartCard({Key? key, required this.cart}) : super(key: key);

  UrunBilgileriSatinAlma cart;

  var urun = <Urun>[];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 88,
          child: AspectRatio(
            aspectRatio: 0.88,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6F9),
                borderRadius: BorderRadius.circular(15),
              ),
              // child: Image.asset(cart.),
            ),
          ),
        ),
        SizedBox(width: getProportionateScreenWidth(20)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cart.urunKodu!,
              style: kFontStili(13),
              maxLines: 2,
            ),
            Text(
              cart.urunAdi!,
              style: const TextStyle(color: Colors.black, fontSize: 16),
              maxLines: 2,
            ),
            const SizedBox(height: 10),
            Text.rich(
              TextSpan(
                text: "₺${cart.birimFiyat}",
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: kPrimaryColor),
                children: [
                  TextSpan(
                      text: " x${cart.miktar}",
                      style: Theme.of(context).textTheme.bodyText1),
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
