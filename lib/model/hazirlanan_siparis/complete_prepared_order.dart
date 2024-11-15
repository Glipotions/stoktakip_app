// models/complete_order_dto.dart
import 'package:stoktakip_app/model/hazirlanan_siparis/hazirlanan_siparis.dart';
import 'package:stoktakip_app/model/hazirlanan_siparis/hazirlanan_siparis_bilgileri.dart';

class CompletePreparedOrderDto {
  final HazirlananSiparis hazirlananSiparis;
  final List<HazirlananSiparisBilgileri> hazirlananSiparisBilgileriList;
  String idempotencyKey;

  CompletePreparedOrderDto(
      {required this.hazirlananSiparis,
      required this.hazirlananSiparisBilgileriList,
      required this.idempotencyKey});

  Map<String, dynamic> toJson() => {
        'hazirlananSiparis': hazirlananSiparis.toJson(),
        'hazirlananSiparisBilgileriList':
            hazirlananSiparisBilgileriList.map((e) => e.toJson()).toList(),
        'idempotencyKey': idempotencyKey
      };
}
