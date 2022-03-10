import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'intro_privacy.dart';



class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  final LocalStorage storage = new LocalStorage('VPN');

  bool isApiRunning = true;

  Future doLogin () async {
    // showAlertDialog(context);
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

    setState(() {
      isApiRunning = false;
    });
    getData();

    // Navigator.pop(context);
    //
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => IntroPrivacy()),
    // );
  }


  Future getData() async {
    var accessToken = storage.getItem('access_token');
    print('accessToken $accessToken');
    http.Response response = await http.get(
      "http://ec2-54-215-101-89.us-west-1.compute.amazonaws.com/api/settings",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':'Bearer $accessToken'
      },
    );

    var r = jsonDecode(response.body);
    List s = r['setting'];
    if(s.isNotEmpty){
var a  = s[0];
var terms_url = a['terms_url'];
storage.setItem('terms_url', terms_url);


var privacy_url = a['privacy_url'];
storage.setItem('privacy_url', privacy_url);


    }

    print('Login response  $r');
    setState(() {

    });
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => IntroPrivacy()),
    );
  }



  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    doLogin();
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
               Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                      Center(child:
                      Image(
                          image: AssetImage('assets/imgs/firevpn.png')),),
              Padding(padding: EdgeInsets.all(50),child: NutsActivityIndicator(
                radius: 25,
                activeColor: Colors.amber,
                inactiveColor: Colors.red,
              ) ,)
              ],)


               ])));;
  }
}
