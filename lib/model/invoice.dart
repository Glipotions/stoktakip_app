import 'package:stoktakip_app/model/satis_fatura.dart';
import 'package:stoktakip_app/model/urun_bilgileri.dart';

import 'customer.dart';
import 'supplier.dart';

class Invoice {
  final InvoiceInfo info;
  // final UrunBilgileri urunBilgileri;
  // final Supplier supplier;
  // final Customer customer;
  final SatisFatura satisFatura;

  // final List<InvoiceItem> items;
  final List<UrunBilgileri> items;

  const Invoice({
    required this.info,
    // required this.urunBilgileri,
    // required this.supplier,
    // required this.customer,
    required this.satisFatura,
    required this.items,
  });
}

class InvoiceInfo {
  final String description;
  final String number;
  // final DateTime date;
  // final DateTime dueDate;

  const InvoiceInfo({
    required this.description,
    required this.number,
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
