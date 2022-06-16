// const host = '192.168.1.200:8081'; //KOTA FABRİKA SERVER
// const host = '192.168.2.150:8081'; // KOTA MAĞAZA SERVER
// const host = '10.0.2.2:5001';
// const host = '192.168.1.129:8082';
String? host;
//85.96.3.83
// const host = '188.59.6.69:8082';
const http = 'http://';
String mainUrl = 'http://$host/api/';

String satisFaturaAddUrl = '${mainUrl}SatisFatura';
Uri satisFaturaGetUrl = Uri.parse('${mainUrl}SatisFatura/getall');
String satisFaturaUpdateUrl = '${mainUrl}SatisFatura/updatesatisfatura';

String satinAlmaFaturaAddUrl = '${mainUrl}SatinAlmaFatura';
Uri satinAlmaFaturaGetUrl = Uri.http(host!, 'SatinAlmaFatura/getall');

String cariHesapAddUrl = '${mainUrl}CariHesap';
String cariHesapGetUrl = '${mainUrl}CariHesap/getall';
String cariHesapGetByIdUrl = '${mainUrl}CariHesap/getbyid?id=';
Uri cariHesapGetUri = Uri.parse('${mainUrl}CariHesap/getall');

String kasaGetByIdUrl(int id) {
  return '${mainUrl}Kasa/getbyid?id=$id';
}

Uri kasaGetUrl = Uri.parse('${mainUrl}Kasa/getall');

String nakitAddUrl = '${mainUrl}Nakit';

String urunBilgileriAddUrl = '${mainUrl}UrunBilgileri';
String urunBilgileriDeleteUrl = '${mainUrl}UrunBilgileri';
String urunBilgileriUpdateUrl = '${mainUrl}UrunBilgileri/update?';
Uri urunBilgileriGetUrl = Uri.http(host!, 'UrunBilgileri/getall');

String urunBilgileriGetBySatisFaturaIdUrl(id) {
  return '${mainUrl}UrunBilgileri/getallbysatisfaturaid?id=$id';
}

String urunBilgileriSatinAlmaAddUrl = '${mainUrl}UrunBilgileriSatinAlma';
Uri urunBilgileriSatinAlmaGetUrl =
    Uri.http(host!, 'UrunBilgileriSatinAlma/getallbysatinalmafaturaid?id=');

String urunBarkodBilgileriAddUrl = '${mainUrl}UrunBarkodBilgileri';
String urunBarkodBilgileriGetUrunUrl =
    '${mainUrl}UrunBarkodBilgileri/getbybarcode?barkod=';
Uri urunBarkodBilgileriGetUrunUri =
    Uri.parse('${mainUrl}UrunBarkodBilgileri/getbybarcode?barkod=');

String urunGetByIdUrl = '${mainUrl}Urun/getbyid?id=';
String urunGetByCodeUrl = '${mainUrl}Urun/getbycode?code=';
String updateUrunById = '${mainUrl}Urun/updateurunbyid?id=';

Uri fetchAlinanSiparisUrl = Uri.parse('${mainUrl}AlinanSiparis/getall');
String updateAlinanSiparisDurumByIdUrl =
    '${mainUrl}AlinanSiparis/updatealinansiparisdurumbyid?id=';

String fetchAlinanSiparisBilgileriByAlinanSiparisIdUrl =
    '${mainUrl}AlinanSiparisBilgileri/getallbyalinansiparisid?id=';
String fetchAlinanSiparisBilgileriByCariIdUrl =
    '${mainUrl}AlinanSiparisBilgileri/getallbycari?id=';
String fetchAlinanSiparisBilgileriByCariIdControlUrl =
    '${mainUrl}AlinanSiparisBilgileri/getallbycaricontrol?id=';
String updateAlinanSiparisBilgileriUrl =
    '${mainUrl}AlinanSiparisBilgileri/update?';

String hazirlananSiparisAddUrl = '${mainUrl}HazirlananSiparis';
Uri fetchHazirlananSiparisUrl = Uri.parse('${mainUrl}HazirlananSiparis/getall');

String hazirlananSiparisBilgileriAddUrl =
    '${mainUrl}HazirlananSiparisBilgileri';
String hazirlananSiparisBilgileriDeleteUrl =
    '${mainUrl}HazirlananSiparisBilgileri/delete';
String hazirlananSiparisBilgileriUpdateUrl =
    '${mainUrl}HazirlananSiparisBilgileri/update?';
String hazirlananSiparisBilgileriGetByHazirlananSiparisIdUrl(id) {
  return '${mainUrl}HazirlananSiparisBilgileri/getallbyhazirlanansiparisid?id=$id';
}

String gelenSiparisAddUrl = '${mainUrl}GelenSiparis';
Uri fetchGelenSiparisUrl = Uri.parse('${mainUrl}GelenSiparis/getall');

String gelenSiparisBilgileriAddUrl = '${mainUrl}GelenSiparisBilgileri';
String gelenSiparisBilgileriDeleteUrl =
    '${mainUrl}GelenSiparisBilgileri/delete';
String gelenSiparisBilgileriUpdateUrl =
    '${mainUrl}GelenSiparisBilgileri/update?';
String gelenSiparisBilgileriGetByGelenSiparisIdUrl(id) {
  return '${mainUrl}GelenSiparisBilgileri/getallbygelensiparisid?id=$id';
}

Uri fetchVerilenSiparisUrl = Uri.parse('${mainUrl}VerilenSiparis/getall');
String updateVerilenSiparisDurumByIdUrl =
    '${mainUrl}VerilenSiparis/updateverilensiparisdurumbyid?id=';

String fetchVerilenSiparisBilgileriByVerilenSiparisIdUrl =
    '${mainUrl}VerilenSiparisBilgileri/getallbyverilensiparisid?id=';
String fetchVerilenSiparisBilgileriByCariIdUrl =
    '${mainUrl}VerilenSiparisBilgileri/getallbycari?id=';
String fetchVerilenSiparisBilgileriByCariIdControlUrl =
    '${mainUrl}VerilenSiparisBilgileri/getallbycaricontrol?id=';
String updateVerilenSiparisBilgileriUrl =
    '${mainUrl}VerilenSiparisBilgileri/update?';

String depoGetByIdUrl(int id) {
  return '${mainUrl}Depo/getbyid?id=$id';
}

Uri depoGetUrl = Uri.parse('${mainUrl}Depo/getall');
