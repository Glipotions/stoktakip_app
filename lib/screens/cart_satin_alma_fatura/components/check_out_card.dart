import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stoktakip_app/components/default_button.dart';
import 'package:stoktakip_app/const/constants.dart';
import 'package:stoktakip_app/functions/const_functions.dart';
import 'package:stoktakip_app/functions/total_calculate.dart';
import 'package:stoktakip_app/model/cari_hesap.dart';
import 'package:stoktakip_app/change_notifier_model/kdv_data.dart';
import 'package:stoktakip_app/model/urun_bilgileri_satin_alma.dart';
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
  final snackBar =
      const SnackBar(content: Text('Satın Alma Faturası Oluşturuldu!'));
  var formKey = GlobalKey<FormState>();

  bool isCheckedKdv = false, isCheckedIskonto = false;
  double _currentSliderValue = cariHesapSingle.iskontoOrani!.toDouble();
  double _iskontoOrani = 0;
  var kdvController = TextEditingController();

  @override
  void dispose() {
    kdvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int kdvOrani = Provider.of<KdvData>(context).kdv;
    return Container(
      key: formKey,
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
                          _iskontoOrani = 0;
                        } else {
                          _iskontoOrani = _currentSliderValue; //değişecek
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
                        for (var item in urunBilgileriSatinAlmaList) {
                          item.kdvOrani = 0;
                          item.kdvTutari = 0;
                          item.tutar = item.kdvHaricTutar + item.kdvOrani;
                          // item.kdvHaricTutar=
                        }
                      } else {
                        for (var item in urunBilgileriSatinAlmaList) {
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
                        "   ${totalTutarHesaplaSatinAlma(urunBilgileriSatinAlmaList).toStringAsFixed(2)}₺",
                        Colors.black),
                    buildTextRich(
                        "- ${iskontoTutarHesapSatinAlma(urunBilgileriSatinAlmaList, _iskontoOrani).toStringAsFixed(2)}₺ İsk.",
                        Colors.green),
                    buildTextRich(
                        "+ ${kdvHesaplaSatinAlma(urunBilgileriSatinAlmaList, _iskontoOrani).toStringAsFixed(2)}₺ Kdv",
                        Colors.red),
                    buildTextRich(
                        "= ${totalTutarwithKdvSatinAlma(urunBilgileriSatinAlmaList, _iskontoOrani).toStringAsFixed(2)}₺",
                        Colors.blue),
                  ],
                ),
                SizedBox(
                  width: getProportionateScreenWidth(190),
                  child: DefaultButton(
                    text: "Alışverişi Tamamla",
                    press: () async {
                      satinAlmaFaturaNew.cariHesapId = cariHesapSingle.id!;
                      satinAlmaFaturaNew.id =
                          urunBilgileriSatinAlmaList.first.satinAlmaFaturaId;
                      satinAlmaFaturaNew.dovizTutar = 0;
                      satinAlmaFaturaNew.iskontoOrani = _iskontoOrani;
                      satinAlmaFaturaNew.iskontoTutari =
                          iskontoTutarHesapSatinAlma(
                              urunBilgileriSatinAlmaList, _iskontoOrani);
                      satinAlmaFaturaNew.kdvHaricTutar =
                          totalTutarHesaplaSatinAlma(
                              urunBilgileriSatinAlmaList);
                      satinAlmaFaturaNew.toplamTutar =
                          totalTutarwithKdvSatinAlma(
                              urunBilgileriSatinAlmaList, _iskontoOrani);
                      satinAlmaFaturaNew.tarih = DateTime.now();
                      satinAlmaFaturaNew.kdvTutari = kdvHesaplaSatinAlma(
                          urunBilgileriSatinAlmaList, _iskontoOrani);

                      satinAlmaFaturaNew.faturaKdvOrani =
                          isCheckedKdv ? kdvOrani : 0;
                      isCheckedKdv
                          ? satinAlmaFaturaNew.kdvSekli = 1
                          : satinAlmaFaturaNew.kdvSekli = 2;
                      await APIServices.postSatinAlmaFatura(satinAlmaFaturaNew);
                      print('SatisFatura Eklendi');

                      cariHesapSingle.bakiye = cariHesapSingle.bakiye! -
                          totalTutarwithKdvSatinAlma(
                              urunBilgileriSatinAlmaList, _iskontoOrani);
                      await APIServices.updateCariBakiyeById(
                          cariHesapSingle.id!, cariHesapSingle.bakiye!);
                      print('Cari Hesap Bakiye Güncellendi.');

                      for (var urun in urunBilgileriSatinAlmaList) {
                        await APIServices.updateUrunStokById(
                            urun.urunId, urun.miktar, false);

                        await APIServices.postUrunBilgileriSatinAlma(urun);
                      }

                      urunBilgileriSatinAlmaList.clear();
                      Navigator.pop(context);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
