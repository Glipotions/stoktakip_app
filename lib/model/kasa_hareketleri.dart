import 'dart:convert';

KasaHareketleri nakitFromJson(String str) =>
    KasaHareketleri.fromJson(json.decode(str));

String nakitToJson(KasaHareketleri data) => json.encode(data.toJson());

class KasaHareketleri {
  KasaHareketleri({
    required this.kasaId,
    this.nakitId,
    this.bankaIslemId,
    this.kasaVirmanId,
    this.kasaAlacakVirmanId,
    required this.id,
  });

  int kasaId;
  int? nakitId;
  int? bankaIslemId;
  int? kasaVirmanId;
  int? kasaAlacakVirmanId;
  int id;

  factory KasaHareketleri.fromJson(Map<String, dynamic> json) =>
      KasaHareketleri(
        kasaId: json["kasaId"],
        nakitId: json["nakitId"],
        bankaIslemId: json["bankaIslemId"],
        kasaVirmanId: json["kasaVirmanId"],
        kasaAlacakVirmanId: json["kasaAlacakVirmanId"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "kasaId": kasaId,
        "nakitId": nakitId,
        "bankaIslemId": bankaIslemId,
        "kasaVirmanId": kasaVirmanId,
        "kasaAlacakVirmanId": kasaAlacakVirmanId,
        "id": id,
      };
}
