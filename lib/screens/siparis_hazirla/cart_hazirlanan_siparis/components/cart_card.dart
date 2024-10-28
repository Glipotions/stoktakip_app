import 'package:flutter/material.dart';
import 'package:stoktakip_app/const/constants.dart';
import 'package:stoktakip_app/const/text_const.dart';
import 'package:stoktakip_app/model/hazirlanan_siparis/hazirlanan_siparis_bilgileri.dart';

class CartCard extends StatelessWidget {
  CartCard(
      {Key? key,
      required this.cart,
      required this.sackNos,
      required this.onSackChange})
      : super(key: key);

  HazirlananSiparisBilgileri cart;
  List<int> sackNos; // Mevcut torba numaralarının listesi
  final Function(int)
      onSackChange; // Seçilen torba numarasını güncellemek için callback fonksiyonu

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cart.urunKodu!,
                style: kFontStili(13),
                maxLines: 2,
              ),
              const SizedBox(height: 5),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Yatay kaydırma özelliği
                child: Text(
                  cart.urunAdi!,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  overflow:
                      TextOverflow.ellipsis, // Taşma durumunda "..." koyar
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: "Toplam: ",
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, color: kPrimaryColor),
                        children: [
                          TextSpan(
                              text: " ${cart.miktar}  | ",
                              style: Theme.of(context).textTheme.bodyMedium),
                          const TextSpan(
                            text: " İlave Edilmiş: ",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: kPrimaryColor),
                          ),
                          TextSpan(
                              text: " ${cart.ilaveEdilmis ?? 0}",
                              style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                  ),
                  cart.sackNo != null
                      ? const Text(
                          "Torba No: ",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: kPrimaryColor),
                        )
                      : const SizedBox(),
                  cart.sackNo != null
                      ? DropdownButton<int>(
                          value:
                              int.parse(cart.sackNo!), // Mevcut torba numarası
                          onChanged: (int? newValue) {
                            if (newValue != null) {
                              onSackChange(
                                  newValue); // Torba numarasını değiştirme işlemi
                            }
                          },
                          items:
                              sackNos.map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text("$value"),
                            );
                          }).toList(),
                        )
                      : const SizedBox(),
                ],
              ),
              // const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}
