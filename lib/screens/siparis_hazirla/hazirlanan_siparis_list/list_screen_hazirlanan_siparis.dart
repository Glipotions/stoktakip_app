import 'package:flutter/material.dart';
import 'components/body.dart';

class ListScreenHazirlananSiparis extends StatefulWidget {
  static String routeName = "/hazirlanan-siparis-list";

  const ListScreenHazirlananSiparis({Key? key}) : super(key: key);

  @override
  State<ListScreenHazirlananSiparis> createState() =>
      _ListScreenHazirlananSiparisState();
}

class _ListScreenHazirlananSiparisState
    extends State<ListScreenHazirlananSiparis> {
  @override
  Widget build(BuildContext context) {
    return const Body();
  }
}
