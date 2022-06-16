import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stoktakip_app/change_notifier_model/gelen_siparis_bilgileri_data.dart';
import 'package:stoktakip_app/components/default_button.dart';
import 'package:stoktakip_app/functions/const_entities.dart';
import 'package:stoktakip_app/model/cari_hesap/cari_hesap.dart';
import 'package:stoktakip_app/model/gelen_urun_siparis/gelen_siparis.dart';
import 'package:stoktakip_app/services/api_services/verilen_siparis_api_service.dart';
import 'package:stoktakip_app/services/api_services/gelen_siparis_api_service.dart';
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
                  child: gelenSiparisDurum == true
                      ? DefaultButton(
                          text: "Siparişi Tamamla",
                          press: () async {
                            // formKey.currentState!.save(); //elimizdeki student oluştu

                            if (_firstPress) {
                              _firstPress = false;
                              int toplam = 0;
                              returnDurum = false;
                              List<String> eksikUrunler = [];
                              for (var item in verilenSiparisBilgileriList) {
                                var durum = gelenSiparisBilgileriList.any(
                                    (element) => element.urunId == item.urunId);
                                if (!durum) {
                                  toplam += 1;
                                  eksikUrunler.add(item.urunKodu.toString());
                                }
                              }

                              await checkEksikOlanUrun(
                                  context, toplam, eksikUrunler);
                              if (returnDurum == false) {
                                gelenSiparisSingle.kod = "X";
                                gelenSiparisSingle.id =
                                    gelenSiparisBilgileriList
                                        .first.gelenSiparisId;

                                gelenSiparisSingle.tarih = DateTime.now();
                                gelenSiparisSingle.depoId = depoGelenSiparis.id;
                                siparisAciklama != null
                                    ? gelenSiparisSingle.aciklama =
                                        siparisAciklama
                                    : satinAlmaFaturaNew.aciklama;

                                var resultSatisFaturaAdd =
                                    await GelenSiparisApiService
                                        .postGelenSiparis(gelenSiparisSingle);

                                for (var item in gelenSiparisBilgileriList) {
                                  item.gelenSiparisId = gelenSiparisSingle.id;
                                  await GelenSiparisApiService
                                      .postGelenSiparisBilgileri(item);

                                  var entity = verilenSiparisBilgileriList
                                      .singleWhere((element) =>
                                          element.urunId == item.urunId);
                                  entity.dovizTuru = 1;
                                  await VerilenSiparisApiService
                                      .updateVerilenSiparisBilgileri(entity);
                                }

                                if (gelenSiparisSingle.isSeciliSiparis!) {
                                  int toplam = 0;
                                  for (var item
                                      in verilenSiparisBilgileriList) {
                                    toplam += item.sipariseGoreKalanAdet!;
                                  }
                                  if (toplam == 0) {
                                    await VerilenSiparisApiService
                                        .updateVerilenSiparisDurumById(
                                            verilenSiparisSingle.id!);
                                  }
                                }

                                //TEMİZLİK KISMI
                                gelenSiparisBilgileriList.clear();
                                Provider.of<GelenSiparisBilgileriData>(context,
                                        listen: false)
                                    .saveListToSharedPref(
                                        gelenSiparisBilgileriGetIdList);

                                faturaAciklama = null;
                                cariHesapSingle = CariHesap(
                                    firma: null,
                                    bakiye: 0,
                                    id: cariHesapSingle.id);

                                gelenSiparisSingle = GelenSiparis();

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

                              int toplam = 0, kalanToplam = 0;
                              returnDurum = false;
                              List<String> eksikUrunler = [];
                              for (var item in verilenSiparisBilgileriList) {
                                var durum = gelenSiparisBilgileriGetIdList.any(
                                    (element) => element.urunId == item.urunId);
                                if (!durum) {
                                  toplam += 1;
                                  eksikUrunler.add(item.urunKodu.toString());
                                }
                                kalanToplam += item.sipariseGoreKalanAdet!;
                              }

                              await checkEksikOlanUrun(
                                  context, toplam, eksikUrunler);
                              if (!returnDurum) {
                                for (var urun
                                    in gelenSiparisBilgileriGetIdList) {
                                  if (urun.insert == true) {
                                    await GelenSiparisApiService
                                        .postGelenSiparisBilgileri(urun);
                                    // await UrunApiService.updateUrunStokById(
                                    //     urun.urunId, urun.miktar, true);
                                    var entity = verilenSiparisBilgileriList
                                        .singleWhere((element) =>
                                            element.urunId == urun.urunId);
                                    entity.dovizTuru = 1;
                                    await VerilenSiparisApiService
                                        .updateVerilenSiparisBilgileri(entity);
                                  } else if (urun.update!) {
                                    urun.dovizTuru = 1;
                                    await GelenSiparisApiService
                                        .updateGelenSiparisBilgileri(urun);
                                    var entity = verilenSiparisBilgileriList
                                        .singleWhere((element) =>
                                            element.urunId == urun.urunId);

                                    entity.dovizTuru = 1;
                                    await VerilenSiparisApiService
                                        .updateVerilenSiparisBilgileri(entity);
                                  }
                                }
                                if (kalanToplam == 0 &&
                                    gelenSiparisEdit.isSeciliSiparis!) {
                                  await VerilenSiparisApiService
                                      .updateVerilenSiparisDurumById(
                                          gelenSiparisEdit.verilenSiparisId!);
                                }

                                gelenSiparisBilgileriSil();

                                //TEMİZLİK KISMI

                                gelenSiparisBilgileriGetIdList.clear();
                                Provider.of<GelenSiparisBilgileriData>(context,
                                        listen: false)
                                    .saveListToSharedPref(
                                        gelenSiparisBilgileriGetIdList);
                                gelenSiparisSingle = GelenSiparis();

                                Navigator.of(context).pop(true);
                                Navigator.of(context).pop(true);
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
      if (gelenSiparisDurum!) {
        for (var item in gelenSiparisBilgileriList) {
          toplam += item.miktar;
        }
      } else {
        for (var item in gelenSiparisBilgileriGetIdList) {
          toplam += item.miktar;
        }
      }
    });
    return toplam.toString();
  }

  void gelenSiparisBilgileriSil() async {
    for (var urunDelete in gelenSiparisBilgileriDeleteList) {
      urunDelete.dovizTuru = 1;

      var entity = verilenSiparisBilgileriList
          .singleWhere((element) => element.urunId == urunDelete.urunId);

      entity.dovizTuru = 1;
      await VerilenSiparisApiService.updateVerilenSiparisBilgileri(entity);

      await GelenSiparisApiService.deleteGelenSiparisBilgileri(urunDelete);
    }
    gelenSiparisBilgileriDeleteList = [];
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
