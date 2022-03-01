import 'dart:convert';

List<UrunBarkodBilgileri> urunBarkodBilgileriFromJson(String str) =>
    List<UrunBarkodBilgileri>.from(
        json.decode(str).map((x) => UrunBarkodBilgileri.fromJson(x)));

String urunBarkodBilgileriToJson(List<UrunBarkodBilgileri> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UrunBarkodBilgileri {
  UrunBarkodBilgileri({
    this.urunId,
    required this.barkod,
  });

  int? urunId;
  String barkod;

  factory UrunBarkodBilgileri.fromJson(Map<String, dynamic> json) =>
      UrunBarkodBilgileri(
        urunId: json["urunId"],
        barkod: json["barkod"],
      );

  Map<String, dynamic> toJson() => {
        "urunId": urunId,
        "barkod": barkod,
      };
}
