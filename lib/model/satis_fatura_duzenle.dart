class SatisFaturaDuzenle {
  double oncekiTutar;
  double? sonTutar;
  String? cariHesapAdi;
  int? cariHesapId;
  int? satisFaturaId;
  String? satisFaturaKod;
  String? satisFaturaAciklama;
  int? satisFaturaOdemeTipi;
  int? satisFaturaKdvSekli;
  int? satisFaturaKdvOrani;
  double? satisFaturaIskontoOrani;
  SatisFaturaDuzenle({
    required this.oncekiTutar,
    this.sonTutar,
    this.cariHesapAdi,
    this.cariHesapId,
    this.satisFaturaId,
    this.satisFaturaKod,
    this.satisFaturaAciklama,
    this.satisFaturaOdemeTipi,
    this.satisFaturaKdvOrani,
    this.satisFaturaIskontoOrani,
    this.satisFaturaKdvSekli,
  });
}

SatisFaturaDuzenle satisFaturaDuzenle = SatisFaturaDuzenle(oncekiTutar: 0);
