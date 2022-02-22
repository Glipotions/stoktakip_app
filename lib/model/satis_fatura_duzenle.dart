class SatisFaturaDuzenle {
  double oncekiTutar;
  double? sonTutar;
  String? cariHesapAdi;
  int? cariHesapId;
  int? satisFaturaId;
  SatisFaturaDuzenle({
    required this.oncekiTutar,
    this.sonTutar,
    this.cariHesapAdi,
    this.cariHesapId,
    this.satisFaturaId,
  });
}

SatisFaturaDuzenle satisFaturaDuzenle = SatisFaturaDuzenle(oncekiTutar: 0);
