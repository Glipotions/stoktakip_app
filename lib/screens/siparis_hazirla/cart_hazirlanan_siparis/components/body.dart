import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stoktakip_app/change_notifier_model/alinan_siparis_bilgileri_data.dart';
import 'package:stoktakip_app/change_notifier_model/hazirlanan_siparis_bilgileri_data.dart';
import 'package:stoktakip_app/functions/const_entities.dart';
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
          buildSearch(),
          Expanded(
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) => Padding(
                key: UniqueKey(),
                padding: EdgeInsets.symmetric(
                    vertical: getProportionateScreenWidth(10)),
                child: Dismissible(
                  key: Key(cart[index].urunId.toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      if (hazirlananSiparisDurum!) {
                        var entity = alinanSiparisBilgileriList.singleWhere(
                            (element) => element.urunId == cart[index].urunId);
                        // entity.kalanMiktar =
                        //     entity.kalanMiktar! + cart[index].miktar;
                        entity.kalanAdet =
                            entity.kalanAdet! + cart[index].miktar;

                        hazirlananSiparisBilgileriList.removeWhere(
                            (urun) => urun.urunId == cart[index].urunId);
                      } else {
                        var entity = alinanSiparisBilgileriList.singleWhere(
                            (element) => element.urunId == cart[index].urunId);
                        entity.kalanAdet =
                            entity.kalanAdet! + cart[index].miktar;

                        hazirlananSiparisBilgileriDeleteList.add(cart[index]);
                        hazirlananSiparisBilgileriGetIdList.removeWhere(
                            (urun) => urun.urunId == cart[index].urunId);
                        // cart.removeAt(index);
                      }
                      if (query != '') {
                        cart.removeAt(index);
                      }
                      (context as Element).reassemble();

                      if (hazirlananSiparisBilgileriList.length > 3) {
                        Provider.of<AlinanSiparisBilgileriData>(context,
                                listen: false)
                            .saveListToSharedPref(alinanSiparisBilgileriList);

                        Provider.of<HazirlananSiparisBilgileriData>(context,
                                listen: false)
                            .saveListToSharedPref(
                                hazirlananSiparisBilgileriList);
                      }
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
        hintText: '??r??n Kodu veya ??r??n Ad??',
        onChanged: searchProduct,
      );
  void searchProduct(String query) {
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
    });
  }
}
