import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stoktakip_app/components/default_button.dart';
import 'package:stoktakip_app/const/constants.dart';
import 'package:stoktakip_app/functions/total_calculate.dart';
import 'package:stoktakip_app/model/cari_hesap.dart';
import 'package:stoktakip_app/model/kdv_data.dart';
import 'package:stoktakip_app/model/satis_fatura.dart';
import 'package:stoktakip_app/model/urun_bilgileri.dart';
import 'package:stoktakip_app/services/api.services.dart';

import '../../../size_config.dart';

class CheckoutCard extends StatefulWidget {
  // const CheckoutCard({
  //   Key? key,
  // }) : super(key: key);

  @override
  State<CheckoutCard> createState() => _CheckoutCardState();
}

class _CheckoutCardState extends State<CheckoutCard> {
  bool isCheckedKdv = false, isCheckedIskonto = false;
  double _currentSliderValue = cariHesapSingle.iskontoOrani!.toDouble();
  double _iskontoOrani = 0;
  var kdvController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    kdvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int kdvOrani = Provider.of<KdvData>(context).kdv;
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
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: Checkbox(
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.resolveWith(getColor),
                    value: isCheckedIskonto,
                    onChanged: (bool? value) {
                      setState(() {
                        isCheckedIskonto = value!;
                        if (value == false) {
                          for (var item in urunBilgileriList) {
                            _iskontoOrani = 0;
                          }
                        } else {
                          for (var item in urunBilgileriList) {
                            _iskontoOrani = _currentSliderValue; //değişecek
                          }
                        }
                      });
                    },
                  ),
                ),
                const Flexible(flex: 2, child: Text("İskonto")),
                SizedBox(width: getProportionateScreenWidth(10)),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: kTextColor,
                ),
                Flexible(
                  flex: 5,
                  child: Slider(
                    value: _currentSliderValue,
                    min: 0,
                    max: 30,
                    divisions: 30,
                    label:
                        "İskonto Oranı: ${_currentSliderValue.round().toString()}",
                    onChanged: (double value) {
                      setState(() {
                        _currentSliderValue = value;
                        _iskontoOrani =
                            isCheckedIskonto == false ? 0 : _currentSliderValue;
                      });
                    },
                  ),
                ),
                Flexible(
                    flex: 2,
                    child:
                        Text("Oran: ${_currentSliderValue.toStringAsFixed(0)}"))
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(5)),
            Row(
              children: [
                Checkbox(
                  checkColor: Colors.white,
                  fillColor: MaterialStateProperty.resolveWith(getColor),
                  value: isCheckedKdv,
                  onChanged: (bool? value) {
                    setState(() {
                      isCheckedKdv = value!;
                      if (value == false) {
                        for (var item in urunBilgileriList) {
                          item.kdvOrani = 0;
                          item.kdvTutari = 0;
                          item.tutar = item.kdvHaricTutar + item.kdvOrani;
                          // item.kdvHaricTutar=
                        }
                      } else {
                        for (var item in urunBilgileriList) {
                          item.kdvOrani = kdvOrani.round();
                          double iskontoUygulanmis = item.kdvHaricTutar -
                              (item.kdvHaricTutar * _iskontoOrani / 100);
                          item.kdvTutari = iskontoUygulanmis * kdvOrani / 100;
                          item.tutar = item.kdvHaricTutar + item.kdvOrani;
                        }
                      }
                    });
                  },
                ),
                const Text("Kdv"),
                SizedBox(width: getProportionateScreenWidth(10)),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: kTextColor,
                ),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    buildTextRich("Toplam: ", Colors.black87),
                    buildTextRich(
                        "   ${totalTutarHesapla(urunBilgileriList).toStringAsFixed(2)}₺",
                        Colors.black),
                    buildTextRich(
                        "- ${iskontoTutarHesap(urunBilgileriList, _iskontoOrani).toStringAsFixed(2)}₺ İsk.",
                        Colors.green),
                    buildTextRich(
                        "+ ${kdvHesapla(urunBilgileriList, _iskontoOrani).toStringAsFixed(2)}₺ Kdv",
                        Colors.red),
                    buildTextRich(
                        "= ${totalTutarwithKdv(urunBilgileriList, _iskontoOrani).toStringAsFixed(2)}₺",
                        Colors.blue),
                  ],
                ),
                SizedBox(
                  width: getProportionateScreenWidth(190),
                  child: DefaultButton(
                    text: "Alışverişi Tamamla",
                    press: () async {
                      // formKey.currentState!.save(); //elimizdeki student oluştu
                      // widget.satisFaturas!.add(satisFatura); //ekleme işlemini yapar.
                      satisFaturaNew.cariHesapId = cariHesapSingle.id!;
                      satisFaturaNew.id = urunBilgileriList.first.satisFaturaId;
                      satisFaturaNew.kod = "Flutter-00003";
                      satisFaturaNew.dovizTutar = 0;
                      satisFaturaNew.iskontoOrani = _iskontoOrani;
                      satisFaturaNew.iskontoTutari =
                          iskontoTutarHesap(urunBilgileriList, _iskontoOrani);
                      satisFaturaNew.kdvHaricTutar =
                          totalTutarHesapla(urunBilgileriList);
                      satisFaturaNew.toplamTutar =
                          totalTutarwithKdv(urunBilgileriList, _iskontoOrani);
                      satisFaturaNew.tarih = DateTime.now();
                      satisFaturaNew.kdvTutari =
                          kdvHesapla(urunBilgileriList, _iskontoOrani);

                      isCheckedKdv
                          ? satisFaturaNew.faturaKdvOrani = kdvOrani.toDouble()
                          : 0;
                      isCheckedKdv
                          ? satisFaturaNew.kdvSekli = 1
                          : satisFaturaNew.kdvSekli = 2;
                      await APIServices.postSatisFatura(satisFaturaNew);
                      print('SatisFatura Eklendi');

                      cariHesapSingle.bakiye = cariHesapSingle.bakiye! +
                          totalTutarwithKdv(urunBilgileriList, _iskontoOrani);
                      await APIServices.updateCariBakiyeById(
                          cariHesapSingle.id!, cariHesapSingle.bakiye!);
                      print('Cari Hesap Bakiye Güncellendi.');

                      for (var urun in urunBilgileriList) {
                        await APIServices.updateUrunStokById(
                            urun.urunId, urun.miktar);

                        await APIServices.postUrunBilgileri(urun);
                      }
                      // for (int i = 0; i < urunBilgileriList.length; i++) {
                      //   await APIServices.postUrunBilgileri(
                      //       urunBilgileriList[i]);
                      // }

                      urunBilgileriList.clear();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
                ),
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
