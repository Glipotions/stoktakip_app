import 'dart:convert';

Kasa kasaFromJson(String str) => Kasa.fromJson(json.decode(str));

String kasaToJson(Kasa data) => json.encode(data.toJson());

class Kasa {
  Kasa({
    this.kasaAdi,
    required this.bakiye,
    required this.id,
  });

  String? kasaAdi;
  double bakiye;
  int id;

  factory Kasa.fromJson(Map<String, dynamic> json) => Kasa(
        kasaAdi: json["kasaAdi"],
        bakiye: json["bakiye"].toDouble(),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "kasaAdi": kasaAdi,
        "bakiye": bakiye,
        "id": id,
      };
}
