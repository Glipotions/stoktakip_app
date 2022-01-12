import 'dart:math';

int buildId() {
  String sifirekle(String deger) {
    if (deger.length == 1) {
      return "0" + deger;
    }
    return deger;
  }

  String ucbasamakyap(String deger) {
    switch (deger.length) {
      case 1:
        return "00" + deger;
      case 2:
        return "0" + deger;
    }
    return deger;
  }

  String id() {
    var yil = sifirekle(DateTime.now().year.toString());
    var ay = sifirekle(DateTime.now().month.toString());
    var gun = sifirekle(DateTime.now().day.toString());
    var saat = sifirekle(DateTime.now().hour.toString());
    var dakika = sifirekle(DateTime.now().minute.toString());
    var saniye = sifirekle(DateTime.now().second.toString());
    var milisaniye = ucbasamakyap(DateTime.now().millisecond.toString());
    var randomYap = sifirekle(Random().nextInt(99).toString());
    return yil + ay + gun + saat + dakika + saniye + milisaniye + randomYap;
  }

  return int.parse(id());
}
