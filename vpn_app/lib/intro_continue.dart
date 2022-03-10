import 'package:flutter/material.dart';
import 'vpn_home.dart';
import 'constant.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:flutter/gestures.dart';

class IntroContinue extends StatefulWidget {
  @override
  _IntroContinueState createState() => _IntroContinueState();
}

class _IntroContinueState extends State<IntroContinue>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  PurchaserInfo _purchaserInfo;
  Offerings _offerings;
  final LocalStorage storage = new LocalStorage('VPN');

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();

    var accessToken = storage.getItem('access_token');
    print("Login from Localstorage $accessToken");

    // if (accessToken == null) {
    //   doLogin();
    // }
    // initPlatformState();
    // fetchData();
  }

  Future getServerData() async {
    showAlertDialog(context);
    var accessToken = storage.getItem('access_token');
    print('accessToken $accessToken');
    http.Response response = await http.get(
      "http://ec2-54-215-101-89.us-west-1.compute.amazonaws.com/api/servers",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken'
      },
    );

    var r = jsonDecode(response.body);
    print('Login response  $r');
    setState(() {
      var _servers = r["server"];
      if (_servers.isNotEmpty) {
        var _selectedItem = _servers[0];
        storage.setItem('_selectedServerItem', _selectedItem);
        print(_selectedItem);
      }
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VpnHome()),
      );
    });
  }

  Future doLogin() async {
    showAlertDialog(context);

    http.Response response = await http.post(
      "http://ec2-54-215-101-89.us-west-1.compute.amazonaws.com/api/auth/login",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': 'admin@gmail.com',
        'password': '123456',
      }),
    );

    var r = jsonDecode(response.body);
    var at = r['access_token'];
    print('Login response  $at');
    storage.setItem('access_token', at);
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 5), child: Text("Loading")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // appData.isPro = false;

    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup("SEeBVLjsQkxzbzGnnftbZbJSTwQTKRLO");

    PurchaserInfo purchaserInfo;
    try {
      purchaserInfo = await Purchases.getPurchaserInfo();
      print(purchaserInfo.toString());
      if (purchaserInfo.entitlements.all['all_features'] != null) {
        // appData.isPro = purchaserInfo.entitlements.all['all_features'].isActive;
      } else {
        // appData.isPro = false;
      }
    } on PlatformException catch (e) {
      print(e);
    }

    // print('#### is user pro? ${appData.isPro}');
  }

  Future<void> fetchData() async {
    Offerings offerings;
    try {
      offerings = await Purchases.getOfferings();
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      _offerings = offerings;
      print("_offerings $offerings");
    });
  }

  void onTapPP() {
    var privacy_url = storage.getItem('privacy_url');
    print('privacy_url $privacy_url');
    if (privacy_url != null) {
      openUrl(privacy_url);
    }
  }

  void onTapTC() {
    var terms_url = storage.getItem('terms_url');
    print('terms_url $terms_url');
    if (terms_url != null) {
      openUrl(terms_url);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/imgs/ic_background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 100, left: 10, right: 10),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                            child: Image(
                                image: AssetImage('assets/imgs/firevpn.png'))),
                        Padding(
                          padding: EdgeInsets.only(top: 120),
                          child: Text(
                            'Fire up your security',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 20, left: 50, right: 50),
                          child: Text(
                            'Secure your connection with fast servers all over the world.',
                            style: TextStyle(
                                fontSize: 16, color: HexColor(FONT_COLOR1)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    //your elements here
                    Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              'Start your 7-day free trial \n Then \$12.99 per month',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(bottom: 80),
                              child: ButtonTheme(
                                minWidth: 300.0,
                                height: 50.0,
                                child: RaisedButton(
                                  onPressed: () {
                                    getServerData();
                                    // Purchases.purchasePackage(_offerings.current.annual);
                                    // print('purchase completed');
                                    // fetchData();
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (context) => VpnHome()),
                                    // );
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      side: BorderSide(color: Colors.red)),
                                  child: const Text('CONTINUE',
                                      style: TextStyle(fontSize: 16)),
                                  color: Colors.red,
                                  textColor: Colors.white,
                                  elevation: 0.0,
                                ),
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  top: 20, left: 30, right: 30, bottom: 30),
                              child: Text.rich(TextSpan(
                                  text: Trial_txt,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: FONT_BOLD,
                                      color: HexColor(FONT_COLOR1)),
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text: 'Terms of Service',
                                      recognizer: new TapGestureRecognizer()
                                        ..onTap = () => {
                                              onTapTC(),
                                              print('Tap Here onTap')
                                            },
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    ),
                                    TextSpan(
                                      text: ' and ',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: HexColor(FONT_COLOR1)),
                                    ),
                                    TextSpan(
                                      text: 'Privacy Policy.',
                                      recognizer: new TapGestureRecognizer()
                                        ..onTap = () => {
                                              onTapPP(),
                                              print('Tap Here onTap')
                                            },
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    )
                                  ]))),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )));
  }
}
