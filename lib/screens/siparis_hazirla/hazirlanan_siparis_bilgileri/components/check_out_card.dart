import 'package:flutter/material.dart';
import 'package:stoktakip_app/functions/const_entities.dart';
import 'package:stoktakip_app/functions/total_calculate.dart';
import 'package:stoktakip_app/model/satis_fatura/urun_bilgileri.dart';
import 'package:stoktakip_app/model/satin_alma/urun_bilgileri_satin_alma.dart';
import 'package:stoktakip_app/size_config.dart';

class CheckoutCard extends StatefulWidget {
  const CheckoutCard({Key? key}) : super(key: key);

  // const CheckoutCard({
  //   Key? key,
  // }) : super(key: key);

  @override
  State<CheckoutCard> createState() => _CheckoutCardState();
}

class _CheckoutCardState extends State<CheckoutCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: getProportionateScreenWidth(15),
          horizontal: getProportionateScreenWidth(30)),
      // height: 174,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.15),
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(children: [
                  buildTextRich(
                      "Sepetteki Ürün Sayısı: ${faturaDurum! ? urunBilgileriList.length : urunBilgileriSatinAlmaList.length}",
                      Colors.black87),
                ]),
                // Column(
                //   children: [
                //     buildTextRich("Toplam: ", Colors.black87),
                //     faturaDurum!
                //         ? buildTextRich(
                //             "   ${totalTutarHesapla(urunBilgileriList).toStringAsFixed(2)}₺",
                //             Colors.black)
                //         : buildTextRich(
                //             "   ${totalTutarHesaplaSatinAlma(urunBilgileriSatinAlmaList).toStringAsFixed(2)}₺",
                //             Colors.black)
                //   ],
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Text buildTextRich(String _text, Color renk) {
    return Text.rich(
      TextSpan(
        text: _text,
        style: TextStyle(fontSize: 16, color: renk),
      ),
    );
  }
}
