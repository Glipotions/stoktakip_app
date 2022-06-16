import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stoktakip_app/change_notifier_model/kasa_data.dart';
import 'package:stoktakip_app/components/default_button.dart';
import 'package:stoktakip_app/const/constants.dart';
import 'package:stoktakip_app/functions/const_entities.dart';
import 'package:stoktakip_app/functions/general_functions.dart';
import 'package:stoktakip_app/functions/total_calculate.dart';
import 'package:stoktakip_app/model/cari_hesap/cari_hesap.dart';
import 'package:stoktakip_app/change_notifier_model/kdv_data.dart';
import 'package:stoktakip_app/model/satis_fatura/satis_fatura.dart';
import 'package:stoktakip_app/model/satis_fatura/urun_bilgileri.dart';
import 'package:stoktakip_app/screens/shared_settings/settings_page.dart';
import 'package:stoktakip_app/services/api_services/nakit_api_service.dart';
import 'package:stoktakip_app/services/api_services/satis_fatura_api_service.dart';
import 'package:stoktakip_app/services/api_services/urun_bilgileri_api_service.dart';

import '../../../size_config.dart';

class CheckoutCard extends StatefulWidget {
  const CheckoutCard({Key? key}) : super(key: key);

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

  bool _firstPress = true;
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
  final _iskontoController = TextEditingController();

  @override
  void dispose() {
    kdvController.dispose();
    _iskontoController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double kdvOrani = Provider.of<KdvData>(context).kdv;
    int? kasaId = Provider.of<KasaData>(context).kasaId;
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
                        } else {
                          _iskontoOrani = _currentSliderValue;
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
                    data: const SliderThemeData(trackHeight: 10),
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
                        }
                      } else {
                        for (var item in urunBilgileriList) {
                          item.kdvOrani = kdvOrani.toDouble();
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
                        if (kasaId! > 0) {
                          satisFaturaNew.odemeTipi = 1;
                        } else {
                          isCheckedNakit = false;
                          Navigator.pushNamed(context, SettingsPage.routeName);
                        }
                      }
                    });
                  },
                ),
                const Text("Nakit"),
                SizedBox(width: getProportionateScreenWidth(10)),
              ],
            ),
            buildTextRich("Toplam Adet: ${toplamMiktar()}", Colors.teal),
            SizedBox(height: getProportionateScreenHeight(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    // buildTextRich(
                    //     "Toplam Adet: ${toplamMiktar()}", Colors.black87),
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
                      if (_firstPress) {
                        _firstPress = false;

                        if (isCheckedIskonto) {
                          for (var item in urunBilgileriList) {
                            item.iskontoOrani = _iskontoOrani;
                            double iskontoTutari = item.kdvHaricTutar -
                                (item.kdvHaricTutar * (_iskontoOrani / 100));
                            item.kdvTutari =
                                (iskontoTutari * item.kdvOrani / 100);
                            item.tutar = iskontoTutari + item.kdvTutari;
                          }
                        } else if (isCheckedKdv) {
                          for (var item in urunBilgileriList) {
                            item.kdvTutari =
                                item.kdvHaricTutar * item.kdvOrani / 100;
                            item.tutar = item.kdvHaricTutar + item.kdvTutari;
                          }
                        }

                        satisFaturaNew.cariHesapId = cariHesapSingle.id!;
                        satisFaturaNew.id =
                            urunBilgileriList.first.satisFaturaId;
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
                            await SatisFaturaApiService.postSatisFatura(
                                satisFaturaNew);

                        cariHesapSingle.bakiye = cariHesapSingle.bakiye! +
                            totalTutarwithKdv(urunBilgileriList, _iskontoOrani);
                        // var resultCarihesapUpdateSatis =
                        //     await CariHesapApiService.updateCariBakiyeById(
                        //         cariHesapSingle.id!,
                        //         totalTutarwithKdv(
                        //             urunBilgileriList, _iskontoOrani),
                        //         "Borc");

                        for (var urun in urunBilgileriList) {
                          // await UrunApiService.updateUrunStokById(
                          //     urun.urunId, urun.miktar, true);

                          await UrunBilgileriApiService.postUrunBilgileri(urun);
                        }

                        if (isCheckedNakit) {
                          double toplamTutar = totalTutarwithKdv(
                              urunBilgileriList, _iskontoOrani);

                          int nakitId = buildId();
                          nakitEntity.cariHesapId = cariHesapSingle.id!;
                          nakitEntity.cariHesapTuru = 2; //Tahsilat=2
                          nakitEntity.dovizTuru = 1; //TL=1
                          nakitEntity.dovizliTutar = 0;
                          nakitEntity.id = nakitId;
                          nakitEntity.tarih = DateTime.now();
                          nakitEntity.kasaId = kasaId!;
                          nakitEntity.tutar = toplamTutar;
                          nakitEntity.aciklama = "Mobil Satış";
                          nakitEntity.makbuzNo = null;

                          var resultNakitAdd =
                              await NakitApiService.postNakit(nakitEntity);

                          if (resultNakitAdd != 200
                              // resultKasaUpdate != 200 ||
                              // resultKasaHareketleriAdd != 200 ||
                              // resultCariHesapHareketleriNakitAdd != 200 ||
                              // resultCarihesapUpdateNakit != 200
                              ) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBarNakitEkle);
                          }
                        }

                        // var resultCariHesapHareketleriSatisAdd =
                        //     await CariHesapApiService.postCariHesapHareketleri(
                        //         cariHesapSingle.id!,
                        //         satisFaturaNew.id,
                        //         "Satis");
                        //TEMİZLİK KISMI
                        urunBilgileriList.clear();
                        faturaAciklama = null;
                        cariHesapSingle = CariHesap(
                            firma: null, bakiye: 0, id: cariHesapSingle.id);

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
                        Navigator.of(context).pop(true);

                        if (
                            // resultCariHesapHareketleriSatisAdd != 200 ||
                            // resultCarihesapUpdateSatis != 200 ||
                            resultSatisFaturaAdd != 200) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(snackBarSatisFaturaEkle);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                'Birden Fazla Tıklamalar Dikkate Alınmadı!')));
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

  String toplamMiktar() {
    int toplam = 0;
    setState(() {
      for (var item in urunBilgileriList) {
        toplam += item.miktar;
      }
    });
    return toplam.toString();
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
