// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stoktakip_app/change_notifier_model/ip_host_data.dart';
import 'package:stoktakip_app/const/api_const.dart';
import 'package:stoktakip_app/model/shared_preferences_models/ip_host.dart';
import 'package:stoktakip_app/screens/home/home_view.dart';

class HostPage extends StatefulWidget {
  static String routeName = "/hostpage";

  const HostPage({Key? key}) : super(key: key);
  @override
  _HostPageState createState() => _HostPageState();
}

List<IpHost> ipHostListe = [];

class _HostPageState extends State<HostPage> {
  bool _isChecked = false;
  Object? dropDownMenu;
  // static SharedPreferences _pref = SharedPreferences as SharedPreferences;

  final TextEditingController _hostNameController = TextEditingController();
  final TextEditingController _ipHostController = TextEditingController();
  final TextEditingController _hostNameAddController = TextEditingController();
  final TextEditingController _ipHostAddController = TextEditingController();

  final snackBarMukerrerHost =
      const SnackBar(content: Text('Aynı Host Adından zaten var!'));
  final snackBarIslemBasarili =
      const SnackBar(content: Text('İşlem Başarılı!'));
  // Future<void> createPrefObject() async {
  //   _pref = await SharedPreferences.getInstance();
  // }

  Future<void> initStateAsync() async {
    Provider.of<IpHostData>(context, listen: false).loadIpHostList();
    // await _loadIpHostList();
  }

  @override
  void initState() {
    _loadUserIpHost();
    // initStateAsync();
    // _loadIpHostList();
    super.initState();
  }

  @override
  void dispose() {
    _hostNameController.dispose();
    _ipHostController.dispose();
    _hostNameAddController.dispose();
    _ipHostAddController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initStateAsync();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Giriş Sayfası"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange[300],
                  shape: BoxShape.rectangle,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10.0),
                  ),
                ),
                child: DropdownButton(
                  alignment: Alignment.center,
                  hint: const Text('Host Seçiniz.'),
                  value: dropDownMenu,
                  items: ipHostListe.map((ipHost) {
                    return DropdownMenuItem(
                      value: ipHost.hostAdi,
                      child: Text(ipHost.hostAdi.toString()),
                      onTap: () {
                        _ipHostController.text = ipHost.ip;
                      },
                    );
                  }).toList(),
                  onChanged: (newValue) async {
                    setState(() {
                      dropDownMenu = newValue;
                    });
                  },
                ),
              ),
            ),
            field(_ipHostController, const Icon(Icons.import_export),
                "Ip:Host Gir"),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
                onTap: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => LogoutPage()));
                  host = _ipHostController.text;
                  Navigator.pushNamed(context, HomeViewPage.routeName);
                },
                child: const Text("Giriş",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 21,
                        fontWeight: FontWeight.bold))),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              SizedBox(
                  height: 24.0,
                  width: 24.0,
                  child: Theme(
                    data: ThemeData(
                        unselectedWidgetColor:
                            const Color(0xff00C8E8) // Your color
                        ),
                    child: Checkbox(
                        activeColor: const Color(0xff00C8E8),
                        value: _isChecked,
                        onChanged: _handleRememberme),
                  )),
              const SizedBox(width: 10.0),
              const Text("Hatırla",
                  style: TextStyle(
                      color: Color(0xff646464),
                      fontSize: 12,
                      fontFamily: 'Rubic'))
            ])
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Column(
                  children: [
                    field(_hostNameAddController,
                        const Icon(Icons.email_outlined), "Host Adı Gir"),
                    const SizedBox(
                      height: 10,
                    ),
                    field(_ipHostAddController, const Icon(Icons.wifi),
                        "Ip:Host Gir"),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                            onTap: () {
                              ipHostListe.removeWhere((item) =>
                                  item.hostAdi == _hostNameAddController.text);
                              _saveIpHostList();
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBarIslemBasarili);
                              // _loadIpHostList();
                              for (var item in ipHostListe) {
                                print(item.hostAdi);
                              }
                            },
                            child: const Text("Sil",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold))),
                        GestureDetector(
                            onTap: () {
                              // Navigator.push(context,
                              //     MaterialPageRoute(builder: (context) => LogoutPage()));
                              int mukerrerHost = ipHostListe
                                  .where((element) =>
                                      element.hostAdi ==
                                      _hostNameAddController.text)
                                  .length;
                              if (mukerrerHost > 0) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBarMukerrerHost);
                              } else {
                                ipHostListe.add(IpHost(
                                    hostAdi: _hostNameAddController.text,
                                    ip: _ipHostAddController.text));
                                _saveIpHostList();
                                // _loadIpHostList();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBarIslemBasarili);
                                for (var item in ipHostListe) {
                                  print(item.hostAdi);
                                }
                              }
                              Navigator.of(context).pop();
                            },
                            child: const Text("Ekle",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ],
                );
              });
        },
      ),
    );
  }

  field(TextEditingController controller, Icon icon, String label) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Colors.white,
              blurRadius: 5.0,
            ),
          ],
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xffECEBEB))),
      child: TextField(
          controller: controller,
          //onChanged: onchange,

          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(top: 8, left: 20),
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            border: InputBorder.none,
            suffixIcon: icon,
            labelText: label,
            labelStyle:
                const TextStyle(fontSize: 14, decoration: TextDecoration.none),
          )),
    );
  }

  void _handleRememberme(bool? value) {
    _isChecked = value!;
    SharedPreferences.getInstance().then(
      (prefs) {
        prefs.setBool("remember_me", value);
        prefs.setString('hostName', dropDownMenu.toString());
        prefs.setString('ipHost', _ipHostController.text);
      },
    );
    setState(() {
      _isChecked = value;
    });
  }

  void _loadUserIpHost() async {
    print("Load Host");
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _hostName = _prefs.getString("hostName") ?? "";
      var _ipHost = _prefs.getString("ipHost") ?? "";
      var _rememberMe = _prefs.getBool("remember_me") ?? false;

      print(_rememberMe);
      print(_hostName);
      print(_ipHost);
      if (_rememberMe) {
        setState(() {
          _isChecked = true;
          dropDownMenu = _hostName;
          _hostNameController.text = _hostName;
          _ipHostController.text = _ipHost;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  // Future _loadIpHostList() async {
  //   SharedPreferences _pref = await SharedPreferences.getInstance();
  //   final String iphostsString = await _pref.getString('ip_host_listesi')!;
  //   final List<IpHost> ipHosts = IpHost.decode(iphostsString);
  //   ipHostListe = ipHosts;
  // }

  void _saveIpHostList() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    final String encodedData = IpHost.encode(ipHostListe);
    await _pref.setString('ip_host_listesi', encodedData);
  }
}

class LogoutPage extends StatelessWidget {
  const LogoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Çıkış"),
        actions: [
          GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HostPage()),
                    (route) => false);
              },
              child: const Icon(Icons.logout))
        ],
      ),
    );
  }
}
