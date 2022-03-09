import 'package:flutter/material.dart';
import 'components/body.dart';

class ListSiparisiGoruntuleTable extends StatefulWidget {
  static String routeName = "/siparisi-goruntule-list";

  const ListSiparisiGoruntuleTable({Key? key}) : super(key: key);

  @override
  State<ListSiparisiGoruntuleTable> createState() =>
      _ListSiparisiGoruntuleTableState();
}

class _ListSiparisiGoruntuleTableState
    extends State<ListSiparisiGoruntuleTable> {
  @override
  Widget build(BuildContext context) {
    return const Body();
  }
}
