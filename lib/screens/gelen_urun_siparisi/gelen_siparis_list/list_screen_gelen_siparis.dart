import 'package:flutter/material.dart';
import 'components/body.dart';

class ListScreenGelenSiparis extends StatefulWidget {
  static String routeName = "/gelen-siparis-list";

  const ListScreenGelenSiparis({Key? key}) : super(key: key);

  @override
  State<ListScreenGelenSiparis> createState() => _ListScreenGelenSiparisState();
}

class _ListScreenGelenSiparisState extends State<ListScreenGelenSiparis> {
  @override
  Widget build(BuildContext context) {
    return const Body();
  }
}
