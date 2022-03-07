import 'package:flutter/material.dart';
import 'package:stoktakip_app/functions/const_entities.dart';
import 'package:stoktakip_app/size_config.dart';

import 'cart_card.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        itemCount: hazirlananSiparisDurum == true
            ? hazirlananSiparisBilgileriList.length
            : hazirlananSiparisBilgileriGetIdList.length,
        itemBuilder: (context, index) => Padding(
          key: UniqueKey(),
          padding:
              EdgeInsets.symmetric(vertical: getProportionateScreenWidth(10)),
          child: Dismissible(
            key: Key(hazirlananSiparisDurum == true
                ? hazirlananSiparisBilgileriList[index].urunId.toString()
                : hazirlananSiparisBilgileriGetIdList[index].urunId.toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              setState(() {
                if (hazirlananSiparisDurum!) {
                  hazirlananSiparisBilgileriList.removeAt(index);
                } else {
                  hazirlananSiparisBilgileriDeleteList
                      .add(hazirlananSiparisBilgileriGetIdList[index]);
                  hazirlananSiparisBilgileriGetIdList.removeAt(index);
                }
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
            child: CartCard(
              cart: hazirlananSiparisDurum == true
                  ? hazirlananSiparisBilgileriList[index]
                  : hazirlananSiparisBilgileriGetIdList[index],
            ),
          ),
        ),
      ),
    );
  }
}
