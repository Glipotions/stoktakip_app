import 'package:flutter/material.dart';
import 'package:stoktakip_app/functions/const_entities.dart';
import 'package:stoktakip_app/screens/siparis_hazirla/siparisi_goruntule/siparisi_goruntule_list.dart';
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
                SizedBox(
                  // width: getProportionateScreenWidth(120),
                  height: getProportionateScreenHeight(60),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.lightBlue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Siparişi Gör"),
                        onPressed: () {
                          Navigator.pushNamed(
                              context, ListSiparisiGoruntuleTable.routeName);
                        }),
                  ),
                ),
                Column(children: [
                  SingleChildScrollView(
                    child: buildTextRich(
                        "Sepetteki Ürün Sayısı: ${hazirlananSiparisDurum == true ? hazirlananSiparisBilgileriList.length : hazirlananSiparisBilgileriGetIdList.length}",
                        Colors.black87),
                  ),
                ]),
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
      maxLines: 2,
    );
  }
}
