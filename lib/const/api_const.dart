const host = '10.0.2.2:5001/api/';
const https = 'https://';
const mainUrl = 'https://10.0.2.2:5001/api/';

const satisFaturaAddUrl = '${mainUrl}SatisFatura';
Uri satisFaturaGetUrl = Uri.http(host, 'satisfatura/getall');

const cariHesapAddUrl = '${mainUrl}CariHesap';
const cariHesapGetUrl = '${mainUrl}CariHesap/getall';
const cariHesapGetByIdUrl = '${mainUrl}CariHesap/getbyid?id=';
Uri cariHesapGetUri = Uri.parse('${mainUrl}CariHesap/getall');

const urunBilgileriAddUrl = '${mainUrl}UrunBilgileri';
Uri urunBilgileriGetUrl = Uri.http(host, 'UrunBilgileri/getall');

const urunBarkodBilgileriAddUrl = '${mainUrl}UrunBarkodBilgileri';
const urunBarkodBilgileriGetUrunUrl =
    '${mainUrl}UrunBarkodBilgileri/getbybarcode?barkod=';
Uri urunBarkodBilgileriGetUrunUri =
    Uri.parse('${mainUrl}UrunBarkodBilgileri/getbybarcode?barkod=');

const urunGetByIdUrl = '${mainUrl}Urun/getbyid?id=';

const updateCariHesapBakiyeById =
    '${mainUrl}CariHesap/updatecaribakiyebyid?id=';
