// models/bulk_edit_order_dto.dart
import 'package:stoktakip_app/model/hazirlanan_siparis/hazirlanan_siparis.dart';
import 'package:stoktakip_app/model/hazirlanan_siparis/hazirlanan_siparis_bilgileri.dart';

class BulkEditOrderDto {
  final HazirlananSiparis hazirlananSiparis;
  final List<HazirlananSiparisBilgileri> insertList;
  final List<HazirlananSiparisBilgileri> updateList;
  final List<HazirlananSiparisBilgileri> deleteList;
  String idempotencyKey;

  BulkEditOrderDto({
    required this.hazirlananSiparis,
    required this.insertList,
    required this.updateList,
    required this.deleteList,
    required this.idempotencyKey
  });

  Map<String, dynamic> toJson() => {
        'hazirlananSiparis': hazirlananSiparis.toJson(),
        'insertList': insertList.map((e) => e.toJson()).toList(),
        'updateList': updateList.map((e) => e.toJson()).toList(),
        'deleteList': deleteList.map((e) => e.toJsonWithId()).toList(),
        'idempotencyKey': idempotencyKey,
      };
}

// Ensure that HazirlananSiparis and HazirlananSiparisBilgileri have toJson methods.