import 'package:flutter/material.dart';
import 'components/body.dart';

class ListScreenSatisFatura extends StatefulWidget {
  static String routeName = "/satisfaturalist";

  const ListScreenSatisFatura({Key? key}) : super(key: key);

  @override
  State<ListScreenSatisFatura> createState() => _ListScreenSatisFaturaState();
}

class _ListScreenSatisFaturaState extends State<ListScreenSatisFatura> {
  @override
  Widget build(BuildContext context) {
    return const Body();
  }
}
