const host = '192.168.1.200:8081/api/';
// const host = '10.0.2.2:5001/api/';
// const host = '192.168.1.129:8082/api/';
// const host = 'stoktakip.local/api';
const http = 'http://';
const mainUrl = 'http://${host}';

const satisFaturaAddUrl = '${mainUrl}SatisFatura';
Uri satisFaturaGetUrl = Uri.http(host, 'SatisFatura/getall');

const satinAlmaFaturaAddUrl = '${mainUrl}SatinAlmaFatura';
Uri satinAlmaFaturaGetUrl = Uri.http(host, 'SatinAlmaFatura/getall');

const cariHesapAddUrl = '${mainUrl}CariHesap';
const cariHesapGetUrl = '${mainUrl}CariHesap/getall';
const cariHesapGetByIdUrl = '${mainUrl}CariHesap/getbyid?id=';
Uri cariHesapGetUri = Uri.parse('${mainUrl}CariHesap/getall');

const urunBilgileriAddUrl = '${mainUrl}UrunBilgileri';
Uri urunBilgileriGetUrl = Uri.http(host, 'UrunBilgileri/getall');

const urunBilgileriSatinAlmaAddUrl = '${mainUrl}UrunBilgileriSatinAlma';
Uri urunBilgileriSatinAlmaGetUrl =
    Uri.http(host, 'UrunBilgileriSatinAlma/getallbysatinalmafaturaid?id=');

const urunBarkodBilgileriAddUrl = '${mainUrl}UrunBarkodBilgileri';
const urunBarkodBilgileriGetUrunUrl =
    '${mainUrl}UrunBarkodBilgileri/getbybarcode?barkod=';
Uri urunBarkodBilgileriGetUrunUri =
    Uri.parse('${mainUrl}UrunBarkodBilgileri/getbybarcode?barkod=');

const urunGetByIdUrl = '${mainUrl}Urun/getbyid?id=';
const urunGetByCodeUrl = '${mainUrl}Urun/getbycode?code=';
const updateUrunById = '${mainUrl}Urun/updateurunbyid?id=';

const updateCariHesapBakiyeById =
    '${mainUrl}CariHesap/updatecaribakiyebyid?id=';
