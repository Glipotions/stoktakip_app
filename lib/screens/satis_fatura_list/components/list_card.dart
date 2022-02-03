import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stoktakip_app/const/constants.dart';
import 'package:stoktakip_app/const/text_const.dart';
import 'package:stoktakip_app/model/cari_hesap.dart';
import 'package:stoktakip_app/model/satis_fatura.dart';
import 'package:stoktakip_app/services/api.services.dart';
import 'package:stoktakip_app/size_config.dart';

class ListCard extends StatefulWidget {
  ListCard({Key? key, required this.cart}) : super(key: key);

  // final UrunBilgileri cart;

  SatisFatura cart;

  @override
  State<ListCard> createState() => _ListCardState();
}

class _ListCardState extends State<ListCard> {
  CariHesap cari = CariHesap(firma: null, bakiye: 0, id: -1);

  @override
  Widget build(BuildContext context) {
    Future<CariHesap> getCariHesapById(int id) async {
      await APIServices.fetchCariHesapById(id).then((response) {
        setState(() {
          dynamic list = json.decode(response.body);
          List data = list;
          cari = data
              .map((model) => CariHesap.fromJson(model))
              .cast<CariHesap>()
              .first;
          print(cariHesapSingle.bakiye);
          print(cariHesapSingle.iskontoOrani);
        });
      });
      return cari;
    }

    getCariHesapById(widget.cart.cariHesapId);
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
              widget.cart.tarih.toIso8601String(),
              style: kFontStili(13),
              maxLines: 2,
            ),
            Text(
              "${cari.firma!} - ${widget.cart.aciklama}",
              style: const TextStyle(color: Colors.black, fontSize: 16),
              maxLines: 2,
            ),
            const SizedBox(height: 10),
            Text.rich(
              TextSpan(
                text: "Tutar: ₺${widget.cart.toplamTutar!.toStringAsFixed(2)}",
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: kPrimaryColor),
                // children: [
                //   TextSpan(
                //       text: " ${widget.cart.}",
                //       style: Theme.of(context).textTheme.bodyText1),
                // ],
              ),
            )
          ],
        )
      ],
    );
  }
}
