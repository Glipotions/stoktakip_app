import 'package:flutter/material.dart';
import 'package:stoktakip_app/functions/const_entities.dart';
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        itemCount: satisFaturaList.length,
        itemBuilder: (context, index) => Padding(
          key: UniqueKey(),
          padding:
              EdgeInsets.symmetric(vertical: getProportionateScreenWidth(10)),
          child: Dismissible(
            key: Key(satisFaturaList[index].id.toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              setState(() {
                satisFaturaList.removeAt(index);
                (context as Element).reassemble();
              });
            },
            background: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE6E6),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: const [
                  Spacer(),
                  Icon(Icons.restore_from_trash),
                  // SvgPicture.asset("assets/icons/Trash.svg"),
                ],
              ),
            ),
            child: ListCard(
              cart: satisFaturaList[index],
            ),
          ),
        ),
      ),
    );
  }
}
