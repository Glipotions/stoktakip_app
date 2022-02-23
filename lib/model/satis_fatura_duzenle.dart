class SatisFaturaDuzenle {
  double oncekiTutar;
  double? sonTutar;
  String? cariHesapAdi;
  int? cariHesapId;
  int? satisFaturaId;
  String? satisFaturaKod;
  String? satisFaturaAciklama;
  SatisFaturaDuzenle({
    required this.oncekiTutar,
    this.sonTutar,
    this.cariHesapAdi,
    this.cariHesapId,
    this.satisFaturaId,
    this.satisFaturaKod,
    this.satisFaturaAciklama,
  });
}

SatisFaturaDuzenle satisFaturaDuzenle = SatisFaturaDuzenle(oncekiTutar: 0);
