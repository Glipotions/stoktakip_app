import 'package:stoktakip_app/model/hazirlanan_siparis/hazirlanan_siparis.dart';
import 'package:stoktakip_app/model/hazirlanan_siparis/hazirlanan_siparis_bilgileri.dart';
import 'package:stoktakip_app/model/satis_fatura/satis_fatura.dart';
import 'package:stoktakip_app/model/satis_fatura/urun_bilgileri.dart';

class InvoiceSatisFatura {
  final InvoiceInfo info;
  // final UrunBilgileri urunBilgileri;
  // final Supplier supplier;
  // final Customer customer;
  final SatisFatura satisFatura;

  // final List<InvoiceItem> items;
  final List<UrunBilgileri> items;

  const InvoiceSatisFatura({
    required this.info,
    // required this.urunBilgileri,
    // required this.supplier,
    // required this.customer,
    required this.satisFatura,
    required this.items,
  });
}

class InvoiceHazirlananSiparis {
  final InvoiceInfo info;
  // final UrunBilgileri urunBilgileri;
  // final Supplier supplier;
  // final Customer customer;
  final HazirlananSiparis hazirlananSiparis;

  // final List<InvoiceItem> items;
  final List<HazirlananSiparisBilgileri> items;

  const InvoiceHazirlananSiparis({
    required this.info,
    required this.hazirlananSiparis,
    required this.items,
  });
}

class InvoiceInfo {
  final String? description;
  final String? number;
  // final DateTime date;
  // final DateTime dueDate;

  const InvoiceInfo({
    this.description,
    this.number,
    // required this.date,
    // required this.dueDate,
  });
}

class InvoiceItem {
  final String description;
  final DateTime date;
  final int quantity;
  final double vat;
  final double unitPrice;

  const InvoiceItem({
    required this.description,
    required this.date,
    required this.quantity,
    required this.vat,
    required this.unitPrice,
  });
}
