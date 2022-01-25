import 'package:flutter/widgets.dart';
import 'package:stoktakip_app/screens/fatura_olustur/fatura_olustur.dart';
import 'package:stoktakip_app/screens/cart/cart_screen.dart';
import 'package:stoktakip_app/screens/shared_settings/settings_page.dart';
import 'package:stoktakip_app/screens/urun_bilgileri/urun_bilgileri_add.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  // SplashScreen.routeName: (context) => SplashScreen(),
  // SignInScreen.routeName: (context) => SignInScreen(),
  // ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  // LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  // SignUpScreen.routeName: (context) => SignUpScreen(),
  // CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  // OtpScreen.routeName: (context) => OtpScreen(),
  // HomeScreen.routeName: (context) => HomeScreen(),
  // DetailsScreen.routeName: (context) => DetailsScreen(),
  CartScreen.routeName: (context) => CartScreen(),
  UrunBilgileriAdd.routeName: (context) => UrunBilgileriAdd(),
  FaturaOlustur.routeName: (context) => FaturaOlustur(),
  SettingsPage.routeName: (context) => SettingsPage(),
  // ProfileScreen.routeName: (context) => ProfileScreen(),
};
