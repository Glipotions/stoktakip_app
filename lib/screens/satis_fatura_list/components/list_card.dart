import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:stoktakip_app/const/constants.dart';
import 'package:stoktakip_app/const/text_const.dart';
import 'package:stoktakip_app/model/cari_hesap.dart';
import 'package:stoktakip_app/model/satis_fatura.dart';
import 'package:stoktakip_app/size_config.dart';

class ListCard extends StatelessWidget {
  ListCard({Key? key, required this.cart}) : super(key: key);

  // final UrunBilgileri cart;

  SatisFatura cart;
  // final Widget? trailing;

  // @override
  // State<ListCard> createState() => _ListCardState();

  CariHesap cari = CariHesap(firma: null, bakiye: 0, id: -1);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          // DateFormat.yMMMd('tr').format(cart.tarih),
          cart.tarih.toIso8601String(),
          style: kFontStili(14),
          maxLines: 2,
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.only(right: getProportionateScreenWidth(30)),
            child: Text(
              "${cart.firmaUnvani} - ${cart.aciklama}",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
              // softWrap: false,
              maxLines: 1,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text.rich(
          TextSpan(
            text: "Tutar: ₺${cart.toplamTutar!.toStringAsFixed(2)}",
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: kPrimaryColor),
          ),
        )
      ],
    );
  }
}
