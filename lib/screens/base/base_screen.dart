import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class BasePageScreen extends StatefulWidget {
  const BasePageScreen({Key? key}) : super(key: key);
}

abstract class BasePageScreenState<Page extends BasePageScreen>
    extends State<Page> {
  bool _isBack = true;
  bool _isCart = true;

  String appBarTitle();

  void onClickBackButton();

  void onClickCart();

  void isBackButton(bool isBack) {
    _isBack = isBack;
  }

  void isCartButton(bool isCart) {
    _isCart = isCart;
  }
}

mixin BaseScreen<Page extends BasePageScreen> on BasePageScreenState<Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.blue.shade200, Colors.pink.shade300])),
          ),
          title: Text(
            appBarTitle(),
            style: const TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: _isBack
              ? IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    onClickBackButton();
                  },
                )
              : Container(),
          actions: [
            _isCart
                ? IconButton(
                    icon: const Icon(
                      Icons.shopping_cart,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      onClickCart();
                    },
                  )
                : Container()
          ],
        ),
        body: Container(
          child: body(),
          color: Colors.white,
        ));
  }

  Widget body();
}
