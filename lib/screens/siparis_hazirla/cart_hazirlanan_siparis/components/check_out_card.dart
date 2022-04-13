import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stoktakip_app/change_notifier_model/hazirlanan_siparis_bilgileri_data.dart';
import 'package:stoktakip_app/components/default_button.dart';
import 'package:stoktakip_app/functions/const_entities.dart';
import 'package:stoktakip_app/model/cari_hesap/cari_hesap.dart';
import 'package:stoktakip_app/model/hazirlanan_siparis/hazirlanan_siparis.dart';
import 'package:stoktakip_app/services/api_services/alinan_siparis_api_service.dart';
import 'package:stoktakip_app/services/api_services/hazirlanan_siparis_api_service.dart';
import 'package:stoktakip_app/services/api_services/urun_api_service.dart';
import 'package:stoktakip_app/size_config.dart';

class CheckoutCard extends StatefulWidget {
  const CheckoutCard({Key? key}) : super(key: key);

  @override
  State<CheckoutCard> createState() => _CheckoutCardState();
}

class _CheckoutCardState extends State<CheckoutCard>
    with TickerProviderStateMixin {
  final snackBar = const SnackBar(content: Text('Sipariş Hazırlandı!'));
  final snackBarSatisFaturaEkle = const SnackBar(
      content: Text('Sipariş Oluştururken 1 hata meydana geldi!'));

  var formKey = GlobalKey<FormState>();

  late AnimationController controller;

  bool _firstPress = true, returnDurum = false;
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

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            SizedBox(height: getProportionateScreenHeight(5)),
            buildTextRich("Toplam Adet: ${toplamMiktar()}", Colors.teal),
            SizedBox(height: getProportionateScreenHeight(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: getProportionateScreenWidth(190),
                  child: hazirlananSiparisDurum == true
                      ? DefaultButton(
                          text: "Siparişi Tamamla",
                          press: () async {
                            // formKey.currentState!.save(); //elimizdeki student oluştu

                            if (_firstPress) {
                              _firstPress = false;
                              int toplam = 0;
                              returnDurum = false;
                              List<String> eksikUrunler = [];
                              for (var item in alinanSiparisBilgileriList) {
                                var durum = hazirlananSiparisBilgileriList.any(
                                    (element) => element.urunId == item.urunId);
                                if (!durum) {
                                  toplam += 1;
                                  eksikUrunler.add(item.urunKodu.toString());
                                }
                              }

                              await checkEksikOlanUrun(
                                  context, toplam, eksikUrunler);
                              if (returnDurum == false) {
                                hazirlananSiparisSingle.kod = "X";
                                hazirlananSiparisSingle.id =
                                    hazirlananSiparisBilgileriList
                                        .first.hazirlananSiparisId;
                                // hazirlananSiparisSingle.alinanSiparisId =
                                //     alinanSiparisSingle.id;
                                hazirlananSiparisSingle.tarih = DateTime.now();
                                siparisAciklama != null
                                    ? hazirlananSiparisSingle.aciklama =
                                        siparisAciklama
                                    : satinAlmaFaturaNew.aciklama;

                                // hazirlananSiparisSingle.dovizTutar = 0;
                                // hazirlananSiparisSingle.iskontoOrani = 0;
                                // hazirlananSiparisSingle.iskontoTutari = 0;
                                // hazirlananSiparisSingle.kdvHaricTutar = 0;
                                // hazirlananSiparisSingle.toplamTutar = 0;
                                // hazirlananSiparisSingle.kdvTutari = 0;
                                // hazirlananSiparisSingle.siparisKdvOrani = 0;

                                var resultSatisFaturaAdd =
                                    await HazirlananSiparisApiService
                                        .postHazirlananSiparis(
                                            hazirlananSiparisSingle);

                                for (var item
                                    in hazirlananSiparisBilgileriList) {
                                  await UrunApiService.updateUrunStokById(
                                      item.urunId, item.miktar, true);
                                  item.hazirlananSiparisId =
                                      hazirlananSiparisSingle.id;
                                  await HazirlananSiparisApiService
                                      .postHazirlananSiparisBilgileri(item);

                                  var entity = alinanSiparisBilgileriList
                                      .singleWhere((element) =>
                                          element.urunId == item.urunId);
                                  entity.dovizTuru = 1;
                                  await AlinanSiparisApiService
                                      .updateAlinanSiparisBilgileri(entity);
                                }

                                //TEMİZLİK KISMI
                                hazirlananSiparisBilgileriList.clear();
                                Provider.of<HazirlananSiparisBilgileriData>(
                                        context,
                                        listen: false)
                                    .saveListToSharedPref(
                                        hazirlananSiparisBilgileriGetIdList);

                                faturaAciklama = null;
                                cariHesapSingle = CariHesap(
                                    firma: null,
                                    bakiye: 0,
                                    id: cariHesapSingle.id);

                                hazirlananSiparisSingle = HazirlananSiparis();

                                Navigator.of(context).pop(true);
                                Navigator.of(context).pop(true);

                                if (resultSatisFaturaAdd != 200) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBarSatisFaturaEkle);
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Birden Fazla Tıklamalar Dikkate Alınmadı!')));
                            }
                          },
                        )
                      : DefaultButton(
                          text: "Düzenle",
                          press: () async {
                            // formKey.currentState!.save(); //elimizdeki student oluştu

                            if (_firstPress) {
                              _firstPress = false;

                              int toplam = 0;
                              returnDurum = false;
                              List<String> eksikUrunler = [];
                              for (var item in alinanSiparisBilgileriList) {
                                var durum = hazirlananSiparisBilgileriGetIdList
                                    .any((element) =>
                                        element.urunId == item.urunId);
                                if (!durum) {
                                  toplam += 1;
                                  eksikUrunler.add(item.urunKodu.toString());
                                }
                              }
                              await checkEksikOlanUrun(
                                  context, toplam, eksikUrunler);
                              if (!returnDurum) {
                                for (var urun
                                    in hazirlananSiparisBilgileriGetIdList) {
                                  if (urun.insert == true) {
                                    await HazirlananSiparisApiService
                                        .postHazirlananSiparisBilgileri(urun);
                                    await UrunApiService.updateUrunStokById(
                                        urun.urunId, urun.miktar, true);
                                    var entity = alinanSiparisBilgileriList
                                        .singleWhere((element) =>
                                            element.urunId == urun.urunId);
                                    // int kalan = entity.kalanMiktar == null
                                    //     ? entity.miktar - urun.miktar
                                    //     : entity.kalanMiktar! - urun.miktar;
                                    // entity.kalanMiktar = kalan >= 0 ? kalan : 0;
                                    entity.dovizTuru = 1;
                                    await AlinanSiparisApiService
                                        .updateAlinanSiparisBilgileri(entity);
                                  } else if (urun.update!) {
                                    urun.dovizTuru = 1;
                                    await HazirlananSiparisApiService
                                        .updateHazirlananSiparisBilgileri(urun);
                                    await UrunApiService.updateUrunStokById(
                                        urun.urunId, urun.ilaveEdilmis!, true);
                                    var entity = alinanSiparisBilgileriList
                                        .singleWhere((element) =>
                                            element.urunId == urun.urunId);

                                    entity.dovizTuru = 1;
                                    await AlinanSiparisApiService
                                        .updateAlinanSiparisBilgileri(entity);
                                  }
                                }
                                hazirlananSiparisBilgileriSil();

                                //TEMİZLİK KISMI

                                hazirlananSiparisBilgileriGetIdList.clear();
                                Provider.of<HazirlananSiparisBilgileriData>(
                                        context,
                                        listen: false)
                                    .saveListToSharedPref(
                                        hazirlananSiparisBilgileriGetIdList);
                                hazirlananSiparisSingle = HazirlananSiparis();

                                Navigator.of(context).pop(true);
                                Navigator.of(context).pop(true);

                                // if (resultSatisFaturaAdd != 200) {
                                //   ScaffoldMessenger.of(context)
                                //       .showSnackBar(snackBarSatisFaturaEkle);
                                // } else {
                                //   ScaffoldMessenger.of(context)
                                //       .showSnackBar(snackBar);
                                // }
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
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
      if (hazirlananSiparisDurum!) {
        for (var item in hazirlananSiparisBilgileriList) {
          toplam += item.miktar;
        }
      } else {
        for (var item in hazirlananSiparisBilgileriGetIdList) {
          toplam += item.miktar;
        }
      }
    });
    return toplam.toString();
  }

  void hazirlananSiparisBilgileriSil() async {
    for (var urunDelete in hazirlananSiparisBilgileriDeleteList) {
      urunDelete.dovizTuru = 1;

      var entity = alinanSiparisBilgileriList
          .singleWhere((element) => element.urunId == urunDelete.urunId);
      // int? kalan = entity.kalanMiktar == null
      //     ? null
      //     : entity.kalanMiktar! + urunDelete.miktar;
      // entity.kalanMiktar = kalan;
      entity.dovizTuru = 1;
      await AlinanSiparisApiService.updateAlinanSiparisBilgileri(entity);
      await UrunApiService.updateUrunStokById(
          urunDelete.urunId, urunDelete.miktar, false);
      await HazirlananSiparisApiService.deleteHazirlananSiparisBilgileri(
          urunDelete);
    }
    hazirlananSiparisBilgileriDeleteList = [];
  }

  checkEksikOlanUrun(
    BuildContext context,
    int toplam,
    List<String> urunler,
  ) async {
    if (toplam > 0) {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('GİRİLMEYEN ÜRÜNLER VAR!'),
              content: Text(
                  'GİRİLMEYEN ÜRÜNLER: $urunler \n\nYİNE DE DEĞİŞİKLİK YAPMADAN SİPARİŞİ TAMAMLAMAK İSTER MİSİNİZ?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    _firstPress = true;
                    returnDurum = true;
                    Navigator.pop(context, 'Hayır');
                  },
                  child: const Text('Hayır'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'Evet');
                    returnDurum = false;
                  },
                  child: const Text('Evet'),
                ),
              ],
            );
          });
    }
  }
}
