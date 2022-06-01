import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stoktakip_app/const/text_const.dart';

abstract class BaseAddToPageScreen extends StatefulWidget {
  const BaseAddToPageScreen({Key? key}) : super(key: key);
}

abstract class BaseAddToPageScreenState<Page extends BaseAddToPageScreen>
    extends State<Page> {
  bool _isBack = true;
  bool _isCart = true;

  String appBarTitle();

  void onClickBackButton();

  bool onWillPopScope();

  void onClickCart();

  void isBackButton(bool isBack) {
    _isBack = isBack;
  }

  void isCartButton(bool isCart) {
    _isCart = isCart;
  }
}

mixin BaseScreen<Page extends BaseAddToPageScreen>
    on BaseAddToPageScreenState<Page> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return onWillPopScope();
      },
      child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.blue.shade200, Colors.pink.shade300])),
            ),
            title: Text(
              appBarTitle(),
              style: kMetinStili,
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
          )),
    );
  }

  Widget body();
}
