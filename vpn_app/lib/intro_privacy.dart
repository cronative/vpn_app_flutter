import 'package:flutter/material.dart';
import 'constant.dart';
import 'intro_continue.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';



class IntroPrivacy extends StatefulWidget {
  @override
  _IntroPrivacyState createState() => _IntroPrivacyState();
}

class _IntroPrivacyState extends State<IntroPrivacy>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  final LocalStorage storage = new LocalStorage('VPN');

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future doLogin () async {
    showAlertDialog(context);
    http.Response response  = await http.post("http://ec2-54-215-101-89.us-west-1.compute.amazonaws.com/api/auth/login",
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
    Navigator.pop(context);

    Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => IntroContinue()),
        );
  }


  void onTapPP(){
    var privacy_url = storage.getItem('privacy_url');
    print('privacy_url $privacy_url');
if(privacy_url != null){
  openUrl(privacy_url);
}
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/imgs/background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 60, left: 10, right: 10),
                  child: Column(
                    children: [Text(
                      "Your privacy is important",
                      style: TextStyle(color: Colors.black, fontFamily: FONT_BOLD, fontSize: 20),
                    ),  Padding(
                  padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                  child: Text.rich(
                        TextSpan(
                            text: PRIVACY_TXT,
                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold, fontFamily: FONT_BOLD, color: HexColor(FONT_COLOR1)),
                            children: <InlineSpan>[
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold, color: Colors.red),
                                recognizer: new TapGestureRecognizer()..onTap = () =>{

                                  onTapPP(),
                                  print('Tap Here onTap')},
                              )
                            ]
                        )
                    ))],
                  ) ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 60, vertical:50),
                    width: double.infinity,
                    child:ButtonTheme(
                      minWidth: 300.0,
                      height: 50.0,
                      child: RaisedButton(
                        onPressed: () {
                          doLogin();
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => IntroContinue()),
                          // );
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            side: BorderSide(color: Colors.red)),
                        child: const Text('Accept and Continue',
                            style: TextStyle(fontSize: 16)),
                        color: Colors.red,
                        textColor: Colors.white,
                        elevation: 0.0,
                      ),
                    )
                  ),
                ),
              ],
            )));
  }
}
