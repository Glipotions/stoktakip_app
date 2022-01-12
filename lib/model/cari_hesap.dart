class CariHesap {
  String? kod;
  String? firma;
  String? tcKimlikNo;
  String? telefon1;
  String? telefon2;
  String? faks;
  String? email;
  String? vergiDairesi;
  String? vergiNo;
  String? sehir;
  double? bakiye;
  String? aciklama;
  bool? durum = true;
  int? id;
  int? iskontoOrani;

  CariHesap(
      {this.kod,
      required this.firma,
      this.tcKimlikNo,
      this.telefon1,
      this.telefon2,
      this.faks,
      this.email,
      this.vergiDairesi,
      this.vergiNo,
      this.sehir,
      required this.bakiye,
      this.aciklama,
      this.durum,
      required this.id,
      this.iskontoOrani});

  CariHesap.fromJson(Map<String, dynamic> json) {
    kod = json['kod'];
    firma = json['firma'];
    tcKimlikNo = json['tcKimlikNo'];
    telefon1 = json['telefon1'];
    telefon2 = json['telefon2'];
    faks = json['faks'];
    email = json['email'];
    vergiDairesi = json['vergiDairesi'];
    vergiNo = json['vergiNo'];
    sehir = json['sehir'];
    bakiye = json['bakiye'];
    aciklama = json['aciklama'];
    durum = json['durum'];
    id = json['id'];
    iskontoOrani = json['iskontoOrani'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['kod'] = kod;
    data['firma'] = firma;
    data['tcKimlikNo'] = tcKimlikNo;
    data['telefon1'] = telefon1;
    data['telefon2'] = telefon2;
    data['faks'] = faks;
    data['email'] = email;
    data['vergiDairesi'] = vergiDairesi;
    data['vergiNo'] = vergiNo;
    data['sehir'] = sehir;
    data['bakiye'] = bakiye;
    data['aciklama'] = aciklama;
    data['durum'] = durum;
    data['id'] = id;
    data["iskontoOrani"] = iskontoOrani;
    return data;
  }
}

CariHesap cariHesapSingle = CariHesap(firma: null, bakiye: 0, id: -1);
