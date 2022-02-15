import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stoktakip_app/change_notifier_model/kasa_data.dart';
import 'package:stoktakip_app/components/default_button.dart';
import 'package:stoktakip_app/const/constants.dart';
import 'package:stoktakip_app/functions/const_entities.dart';
import 'package:stoktakip_app/functions/general_functions.dart';
import 'package:stoktakip_app/functions/total_calculate.dart';
import 'package:stoktakip_app/model/cari_hesap.dart';
import 'package:stoktakip_app/change_notifier_model/kdv_data.dart';
import 'package:stoktakip_app/model/satis_fatura.dart';
import 'package:stoktakip_app/model/urun_bilgileri.dart';
import 'package:stoktakip_app/screens/fatura_olustur/fatura_olustur.dart';
import 'package:stoktakip_app/services/api.services.dart';

import '../../../size_config.dart';

class CheckoutCard extends StatefulWidget {
  // const CheckoutCard({
  //   Key? key,
  // }) : super(key: key);

  @override
  State<CheckoutCard> createState() => _CheckoutCardState();
}

class _CheckoutCardState extends State<CheckoutCard>
    with TickerProviderStateMixin {
  final snackBar = const SnackBar(content: Text('Satış Faturası Oluşturuldu!'));
  final snackBarSatisFaturaEkle = const SnackBar(
      content: Text('Satış Faturası Oluştururken 1 hata meydana geldi!'));
  final snackBarNakitEkle =
      const SnackBar(content: Text('Nakit Eklerken bir hata meydana geldi!'));

  var formKey = GlobalKey<FormState>();

  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);
    super.initState();
  }

  final GlobalKey<ScaffoldMessengerState> snackbarKey =
      GlobalKey<ScaffoldMessengerState>();

  bool isCheckedKdv = false, isCheckedIskonto = false, isCheckedNakit = false;
  // double _currentSliderValue = cariHesapSingle.iskontoOrani!.toDouble();
  double _currentSliderValue = 15;

  double _iskontoOrani = 0;
  var kdvController = TextEditingController();
  var _iskontoController = TextEditingController();

  @override
  void dispose() {
    kdvController.dispose();
    _iskontoController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int kdvOrani = Provider.of<KdvData>(context).kdv;
    int kasaId = Provider.of<KasaData>(context).kasaId!;
    _iskontoController.text = "0";
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
                          for (var item in urunBilgileriList) {
                            item.tutar = item.kdvHaricTutar + item.kdvTutari;
                          }
                        } else {
                          _iskontoOrani = _currentSliderValue; //değişecek
                          for (var item in urunBilgileriList) {
                            item.tutar = item.kdvHaricTutar +
                                item.kdvTutari -
                                (((item.kdvHaricTutar + item.kdvTutari) *
                                        _currentSliderValue) /
                                    100);
                            // item.kdvHaricTutar=
                          }
                        }
                      });
                    },
                  ),
                ),
                const Flexible(flex: 2, child: Text("İskonto")),
                SizedBox(width: getProportionateScreenWidth(5)),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: kTextColor,
                ),
                Flexible(
                  flex: 7,
                  // child: buildIskonto(),

                  child: SliderTheme(
                    data: SliderThemeData(trackHeight: 10),
                    child: Slider(
                      value: _currentSliderValue,
                      min: 0,
                      max: 20,
                      divisions: 20,
                      label:
                          "İskonto Oranı: ${_currentSliderValue.round().toString()}",
                      onChanged: (double value) {
                        setState(() {
                          _currentSliderValue = value;
                          _iskontoOrani = isCheckedIskonto == false
                              ? 0
                              : _currentSliderValue;
                        });
                      },
                    ),
                  ),
                ),
                Flexible(
                    flex: 2,
                    child: Text("Oran: ${_currentSliderValue.toInt()}"))
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
                          item.tutar = _iskontoOrani == 0
                              ? item.kdvHaricTutar + item.kdvOrani
                              : item.kdvHaricTutar +
                                  item.kdvTutari -
                                  (((item.kdvHaricTutar + item.kdvTutari) *
                                          _currentSliderValue) /
                                      100);
                          // item.kdvHaricTutar=
                        }
                      } else {
                        for (var item in urunBilgileriList) {
                          item.kdvOrani = kdvOrani.toDouble();
                          double iskontoUygulanmis = item.kdvHaricTutar -
                              (item.kdvHaricTutar * _iskontoOrani / 100);
                          item.kdvTutari = iskontoUygulanmis * kdvOrani / 100;
                          item.tutar = item.tutar = _iskontoOrani == 0
                              ? item.kdvHaricTutar + item.kdvOrani
                              : item.kdvHaricTutar +
                                  item.kdvTutari -
                                  (((item.kdvHaricTutar + item.kdvTutari) *
                                          _currentSliderValue) /
                                      100);
                        }
                      }
                    });
                  },
                ),
                const Text("Kdv"),
                SizedBox(width: getProportionateScreenWidth(100)),

                // const Icon(
                //   Icons.money,
                //   size: 12,
                //   color: kTextColor,
                // ),
                Checkbox(
                  checkColor: Colors.white,
                  fillColor: MaterialStateProperty.resolveWith(getColor),
                  value: isCheckedNakit,
                  onChanged: (bool? value) {
                    setState(() {
                      isCheckedNakit = value!;
                      if (value == false) {
                        //Nakit Enum'ı 1 te
                        satisFaturaNew.odemeTipi = 0;
                      } else {
                        satisFaturaNew.odemeTipi = 1;
                      }
                    });
                  },
                ),
                const Text("Nakit"),
                SizedBox(width: getProportionateScreenWidth(10)),
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
                      const CircularProgressIndicator(
                        value: 0.5,
                        backgroundColor: Colors.grey,
                        strokeWidth: 8,
                      );
                      satisFaturaNew.cariHesapId = cariHesapSingle.id!;
                      satisFaturaNew.id = urunBilgileriList.first.satisFaturaId;
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

                      satisFaturaNew.faturaKdvOrani =
                          isCheckedKdv ? kdvOrani.toDouble() : 0;
                      faturaAciklama != null
                          ? satisFaturaNew.aciklama = faturaAciklama
                          : satinAlmaFaturaNew.aciklama;

                      satisFaturaNew.odemeTipi = isCheckedNakit ? 1 : 0;

                      isCheckedKdv
                          ? satisFaturaNew.kdvSekli = 1
                          : satisFaturaNew.kdvSekli = 2;
                      var resultSatisFaturaAdd =
                          await APIServices.postSatisFatura(satisFaturaNew);
                      print('SatisFatura Eklendi');

                      cariHesapSingle.bakiye = cariHesapSingle.bakiye! +
                          totalTutarwithKdv(urunBilgileriList, _iskontoOrani);
                      var resultCarihesapUpdateSatis =
                          await APIServices.updateCariBakiyeById(
                              cariHesapSingle.id!,
                              totalTutarwithKdv(
                                  urunBilgileriList, _iskontoOrani),
                              "Borc");
                      print('Cari Hesap Bakiye Güncellendi.');

                      for (var urun in urunBilgileriList) {
                        await APIServices.updateUrunStokById(
                            urun.urunId, urun.miktar, true);

                        await APIServices.postUrunBilgileri(urun);
                      }

                      if (isCheckedNakit) {
                        double toplamTutar =
                            totalTutarwithKdv(urunBilgileriList, _iskontoOrani);

                        int nakitId = buildId();
                        nakitEntity.cariHesapId = cariHesapSingle.id!;
                        nakitEntity.cariHesapTuru = 2; //Tahsilat=2
                        nakitEntity.dovizTuru = 1; //TL=1
                        nakitEntity.dovizliTutar = 0;
                        nakitEntity.id = nakitId;
                        nakitEntity.tarih = DateTime.now();
                        nakitEntity.kasaId = kasaId;
                        nakitEntity.tutar = toplamTutar;
                        nakitEntity.aciklama = "Mobil Satış";
                        nakitEntity.makbuzNo = null;

                        var resultNakitAdd =
                            await APIServices.postNakit(nakitEntity);

                        var resultKasaUpdate =
                            await APIServices.updateKasa(kasaId, toplamTutar);

                        var resultKasaHareketleriAdd =
                            await APIServices.postKasaHareketleri(
                                kasaId, nakitId, "Nakit");
                        var resultCarihesapUpdateNakit =
                            await APIServices.updateCariBakiyeById(
                                cariHesapSingle.id!,
                                totalTutarwithKdv(
                                    urunBilgileriList, _iskontoOrani),
                                "Odeme");
                        var resultCariHesapHareketleriNakitAdd =
                            await APIServices.postCariHesapHareketleri(
                                cariHesapSingle.id!, nakitId, "Nakit");

                        if (resultNakitAdd != 200 ||
                            resultKasaUpdate != 200 ||
                            resultKasaHareketleriAdd != 200 ||
                            resultCariHesapHareketleriNakitAdd != 200 ||
                            resultCarihesapUpdateNakit != 200) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(snackBarNakitEkle);
                        }
                      }

                      var resultCariHesapHareketleriSatisAdd =
                          await APIServices.postCariHesapHareketleri(
                              cariHesapSingle.id!, satisFaturaNew.id, "Satis");
                      //TEMİZLİK KISMI
                      urunBilgileriList.clear();
                      faturaAciklama = null;
                      cariHesapSingle =
                          CariHesap(firma: null, bakiye: 0, id: -1);

                      satisFaturaNew = SatisFatura(
                          cariHesapId: 1,
                          kod: "Deneme-0001",
                          aciklama: "Mobil Satış",
                          faturaTuru: 3,
                          dovizTuru: 1,
                          dovizKuru: 1,
                          tarih: DateTime.now(),
                          kdvSekli: 1,
                          odemeTipi: 0,
                          durum: true,
                          id: 1);

                      Navigator.of(context).pop(true);
                      // Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FaturaOlustur()));
                      if (resultCariHesapHareketleriSatisAdd != 200 ||
                          resultCarihesapUpdateSatis != 200 ||
                          resultSatisFaturaAdd != 200) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(snackBarSatisFaturaEkle);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
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

  // Widget buildIskonto() {
  //   return SizedBox(
  //     key: UniqueKey(),
  //     height: 40,
  //     // decoration: BoxDecorationSettings(),
  //     child: TextFormField(
  //       controller: _iskontoController,
  //       keyboardType: TextInputType.number,
  //       inputFormatters: [
  //         FilteringTextInputFormatter.deny(','),
  //       ],
  //       decoration: const InputDecoration(
  //         labelText: "İskonto Giriniz.",
  //         hintText: "Sayı Giriniz.",
  //       ),
  //       onEditingComplete: () => setState(() {
  //         _iskontoOrani = double.parse(_iskontoController.text);
  //       }),
  //       style: kMetinStili,
  //       validator: (val) {
  //         if (val!.isEmpty) {
  //           return "İskonto Boş Bırakılamaz.";
  //         } else {
  //           return null;
  //         }
  //       },
  //     ),
  //   );
  // }
}
