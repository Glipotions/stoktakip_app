import 'package:flutter/material.dart';
import 'components/body.dart';

class ListGelenSiparisiGoruntuleTable extends StatefulWidget {
  static String routeName = "/gelen-siparisi-goruntule-list";

  const ListGelenSiparisiGoruntuleTable({Key? key}) : super(key: key);

  @override
  State<ListGelenSiparisiGoruntuleTable> createState() =>
      _ListGelenSiparisiGoruntuleTableState();
}

class _ListGelenSiparisiGoruntuleTableState
    extends State<ListGelenSiparisiGoruntuleTable> {
  @override
  Widget build(BuildContext context) {
    return const Body();
  }
}
