import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stoktakip_app/functions/const_entities.dart';
import 'package:stoktakip_app/model/satis_fatura.dart';
import 'package:stoktakip_app/services/api.services.dart';
import 'package:stoktakip_app/size_config.dart';

import 'list_card.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  // final UrunBilgileri satisFaturaList;
  // const Body(this._urunBilgileri);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future<List> _getSatisFaturas() async {
    await APIServices.fetchSatisFatura().then((response) {
      setState(() {
        dynamic list = json.decode(response.body);
        // List data = list['data'];
        List data = list;
        satisFaturaList =
            data.map((model) => SatisFatura.fromJson(model)).toList();
      });
    });
    return satisFaturaList;
  }

  Future<void> initStateAsync() async {
    await _getSatisFaturas();
  }

  @override
  void initState() {
    initStateAsync();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
          itemCount: satisFaturaList.length,
          itemBuilder: (_, index) {
            return Padding(
              key: UniqueKey(),
              padding: EdgeInsets.symmetric(
                  vertical: getProportionateScreenWidth(10)),
              child: ListCard(
                cart: satisFaturaList[index],
                trailing: PopupMenuButton(
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                        value: 'SatisRaporu',
                        child: Text("Satış Raporu"),
                      )
                    ];
                  },
                  onSelected: (String value) {},
                ),
              ),
              // child: Dismissible(
              //   key: Key(satisFaturaList[index].id.toString()),
              //   direction: DismissDirection.endToStart,
              //   onDismissed: (direction) {
              //     setState(() {
              //       satisFaturaList.removeAt(index);
              //       (context as Element).reassemble();
              //     });
              //   },
              //   background: Container(
              //     padding: const EdgeInsets.symmetric(horizontal: 20),
              //     decoration: BoxDecoration(
              //       color: const Color(0xFFFFE6E6),
              //       borderRadius: BorderRadius.circular(15),
              //     ),
              //     child: Row(
              //       children: const [
              //         Spacer(),
              //         Icon(Icons.restore_from_trash),
              //         // SvgPicture.asset("assets/icons/Trash.svg"),
              //       ],
              //     ),
              //   ),
              //   child: ListCard(
              //     cart: satisFaturaList[index],
              //   ),
              // ),
            );
            return ListTile(
                leading: const CircleAvatar(
                  child: Text('Deneme'),
                ),
                title: Text('Satış Faturası'),
                trailing: PopupMenuButton(
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                        value: 'SatisRaporu',
                        child: Text("Satış Raporu"),
                      )
                    ];
                  },
                  onSelected: (String value) {},
                ));
          }),
    );
  }

  void actionPopUpItemSelected(String value, String name) {
    String message;
    if (value == 'SatisRaporu') {
      message = "x";
      // You can navigate the user to edit page.
    } else if (value == 'delete') {
      message = 'You selected delete for $name';
      // You can delete the item.
    } else {
      message = 'Not implemented';
    }
    print(message);
  }
}
