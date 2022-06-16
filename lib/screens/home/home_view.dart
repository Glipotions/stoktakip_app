import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stoktakip_app/components/mycontainer.dart';
import 'package:stoktakip_app/components/mycontainer_column.dart';
import 'package:stoktakip_app/const/text_const.dart';
import 'package:stoktakip_app/screens/fatura_olustur/fatura_olustur.dart';
import 'package:stoktakip_app/screens/gelen_urun_siparisi/gelen_siparis_hazirla.dart';
import 'package:stoktakip_app/screens/siparis_hazirla/siparis_hazirla.dart';

class HomeViewPage extends StatefulWidget {
  static String routeName = "/home-view-page";
  const HomeViewPage({Key? key}) : super(key: key);

  @override
  _HomeViewPageState createState() => _HomeViewPageState();
}

class _HomeViewPageState extends State<HomeViewPage> {
  DateTime timeBackPressed = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final difference = DateTime.now().difference(timeBackPressed);
        final isExitWarning = difference >= const Duration(seconds: 2);
        timeBackPressed = DateTime.now();

        if (isExitWarning) {
          const message = 'Programdan çıkış yapmak için bir daha tıklayınız.';
          // Fluttertoast.showToast(msg: message, fontSize: 18);
          return false;
        } else {
          // Fluttertoast.cancel();
          SystemNavigator.pop();

          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Glipotions Ön Muhasebe',
            style: TextStyle(color: Colors.black87),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: MyContainer(
                      child: MyContainerColumn(
                        icon: FontAwesomeIcons.apple,
                        yazi: 'BOŞ',
                      ),
                    ),
                  ),
                  Expanded(
                    child: MyContainer(
                      // renk: Colors.green[200],
                      onPress: () {},
                      child: MyContainerColumn(
                        icon: FontAwesomeIcons.android,
                        yazi: 'BOŞ',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: MyContainer(
                renk: Colors.lightBlue[300],
                onPress: () {
                  Navigator.pushNamed(context, FaturaOlustur.routeName);
                },
                child: MyContainerColumn(
                  yazi: "FATURALAR",
                  icon: FontAwesomeIcons.moneyBillWave,
                ),
                // child: Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text(
                //       'FATURALAR',
                //       style: kBaslikStili,
                //     ),
                //   ],
                // ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: MyContainer(
                      renk: Colors.deepPurple[200],
                      onPress: () {
                        Navigator.pushNamed(context, SiparisHazirla.routeName);
                      },
                      child: MyContainerColumn(
                        yazi: "SİPARİŞLER",
                        icon: FontAwesomeIcons.arrowCircleUp,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: MyContainer(
                      renk: Colors.deepOrange[200],
                      onPress: () {
                        Navigator.pushNamed(
                            context, GelenSiparisHazirla.routeName);
                      },
                      child: MyContainerColumn(
                        yazi: "GELEN SİPARİŞLER",
                        icon: FontAwesomeIcons.arrowCircleDown,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: MyContainer(
                      child: MyContainerColumn(
                        icon: FontAwesomeIcons.appleAlt,
                        yazi: 'BOŞ',
                      ),
                    ),
                  ),
                  Expanded(
                    child: MyContainer(
                      // renk: Colors.green[200],
                      onPress: () {},
                      child: MyContainerColumn(
                        icon: FontAwesomeIcons.baseballBall,
                        yazi: 'BOŞ',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row buildRowOutlinedButton(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RotatedBox(
          quarterTurns: -1,
          child: Text(
            text,
            style: kMetinStili,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [],
        )
      ],
    );
  }
}
