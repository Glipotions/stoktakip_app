import 'package:flutter/material.dart';
import 'package:stoktakip_app/functions/const_entities.dart';
import 'package:stoktakip_app/model/hazirlanan_siparis/hazirlanan_siparis.dart';
import 'package:stoktakip_app/model/hazirlanan_siparis/hazirlanan_siparis_bilgileri.dart';
import 'package:stoktakip_app/size_config.dart';
import 'package:stoktakip_app/widget/search_widget.dart';

import 'cart_card.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String query = '';
  late List<HazirlananSiparisBilgileri> cart, constCart;

  @override
  void initState() {
    super.initState();
    cart = hazirlananSiparisDurum == true
        ? hazirlananSiparisBilgileriList
        : hazirlananSiparisBilgileriGetIdList;
    constCart = hazirlananSiparisDurum == true
        ? hazirlananSiparisBilgileriList
        : hazirlananSiparisBilgileriGetIdList;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // SearchWidget(
          //   text: query,
          //   hintText: 'Ürün Kodu veya Ürün Adı',
          //   onChanged: (query) {
          //     searchProduct(query, cart);
          //   },
          // ),
          buildSearch(),
          Expanded(
            child: ListView.builder(
              // itemCount: hazirlananSiparisDurum == true
              //     ? hazirlananSiparisBilgileriList.length
              //     : hazirlananSiparisBilgileriGetIdList.length,
              itemCount: cart.length,
              itemBuilder: (context, index) => Padding(
                key: UniqueKey(),
                padding: EdgeInsets.symmetric(
                    vertical: getProportionateScreenWidth(10)),
                child: Dismissible(
                  // key: Key(hazirlananSiparisDurum == true
                  //     ? hazirlananSiparisBilgileriList[index].urunId.toString()
                  //     : hazirlananSiparisBilgileriGetIdList[index].urunId.toString()),
                  key: Key(cart[index].urunId.toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      if (hazirlananSiparisDurum!) {
                        // var entity = alinanSiparisBilgileriList.singleWhere(
                        //     (element) =>
                        //         element.urunId ==
                        //         hazirlananSiparisBilgileriList[index].urunId);
                        // entity.kalanMiktar = entity.kalanMiktar! +
                        //     hazirlananSiparisBilgileriList[index].miktar;
                        // hazirlananSiparisBilgileriList.removeAt(index);

                        var entity = alinanSiparisBilgileriList.singleWhere(
                            (element) => element.urunId == cart[index].urunId);
                        entity.kalanMiktar =
                            entity.kalanMiktar! + cart[index].miktar;

                        hazirlananSiparisBilgileriList.removeWhere(
                            (urun) => urun.urunId == cart[index].urunId);
                      } else {
                        // var entity = alinanSiparisBilgileriList.singleWhere(
                        //     (element) =>
                        //         element.urunId ==
                        //         hazirlananSiparisBilgileriGetIdList[index]
                        //             .urunId);
                        // entity.kalanMiktar = entity.kalanMiktar! +
                        //     hazirlananSiparisBilgileriGetIdList[index].miktar;

                        // hazirlananSiparisBilgileriDeleteList
                        //     .add(hazirlananSiparisBilgileriGetIdList[index]);
                        // hazirlananSiparisBilgileriGetIdList.removeAt(index);

                        var entity = alinanSiparisBilgileriList.singleWhere(
                            (element) => element.urunId == cart[index].urunId);
                        entity.kalanMiktar =
                            entity.kalanMiktar! + cart[index].miktar;

                        hazirlananSiparisBilgileriDeleteList.add(cart[index]);
                        hazirlananSiparisBilgileriGetIdList.removeWhere(
                            (urun) => urun.urunId == cart[index].urunId);
                        // cart.removeAt(index);
                      }
                      if (query != '') {
                        cart.removeAt(index);
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
                    cart: cart[index],
                  ),
                  // child:
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Ürün Kodu veya Ürün Adı',
        onChanged: searchProduct,
      );
  void searchProduct(String query) {
    // List<HazirlananSiparisBilgileri> cart = hazirlananSiparisDurum == true
    //     ? hazirlananSiparisBilgileriList
    //     : hazirlananSiparisBilgileriGetIdList;
    final products = constCart.where((urun) {
      final urunLower = urun.urunKodu!.toLowerCase();
      final urunAdiLower = urun.urunAdi!.toLowerCase();
      final searchLower = query.toLowerCase();

      return urunLower.contains(searchLower) ||
          urunAdiLower.contains(searchLower);
    }).toList();

    setState(() {
      this.query = query;
      cart = products;
      // if (query == "") {
      //   cart = constCart;
      // }
    });
  }
}
