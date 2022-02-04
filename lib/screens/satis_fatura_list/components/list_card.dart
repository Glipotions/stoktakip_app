import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stoktakip_app/const/constants.dart';
import 'package:stoktakip_app/const/text_const.dart';
import 'package:stoktakip_app/model/cari_hesap.dart';
import 'package:stoktakip_app/model/satis_fatura.dart';
import 'package:stoktakip_app/services/api.services.dart';
import 'package:stoktakip_app/size_config.dart';

class ListCard extends StatelessWidget {
  ListCard({Key? key, required this.cart}) : super(key: key);

  // final UrunBilgileri cart;

  SatisFatura cart;

  // @override
  // State<ListCard> createState() => _ListCardState();

  CariHesap cari = CariHesap(firma: null, bakiye: 0, id: -1);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          cart.tarih.toIso8601String(),
          style: kFontStili(14),
          maxLines: 2,
        ),
        Text(
          "${cart.firmaUnvani} - ${cart.aciklama}",
          style: const TextStyle(color: Colors.black, fontSize: 16),
          maxLines: 2,
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
