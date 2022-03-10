import 'package:flutter/material.dart';
import 'constant.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  final LocalStorage storage = new LocalStorage('VPN');


  final List<ItemModel> _items = [
    ItemModel(0, Icons.restore, 'Restore purchases', 'Some info'),
    ItemModel(1, Icons.star, 'Rate the app', 'Some info'),
    ItemModel(2, Icons.person, 'Support', 'Some info'),
    ItemModel(3, Icons.info_outline_rounded,  'About', 'Some info'),
  ];


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
    print('Login response  $r');
    setState(() {

    });

    // print('_servers response  $_servers');
    // storage.setItem('access_token', at);
    if (response.statusCode == 201) {
      // print('Login response  $response');
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      // return Album.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      // throw Exception('Failed to load album');
    }
  }


  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    getData();
    setState(() {

    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(
            "Settings",
            style: TextStyle(color: Colors.black, fontFamily: FONT_BOLD),
          ),
          actions: [ new IconButton(
            icon: Icon(Icons.close),
            color: Colors.black,
            iconSize:40,
            onPressed: () {
              Navigator.pop(context);

            },
          ),],
        ),
        body: Container(
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/imgs/background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: ListView.builder(
              // Let the ListView know how many items it needs to build.
                itemCount: _items.length,
                // Provide a builder function. This is where the magic happens.
                // Convert each item into a widget based on the type of item it is.
                itemBuilder: (context, index) {
                  final item = _items[index];

                  return InkWell( // Enables taps for child and add ripple effect when child widget is long pressed.
                    onTap: (){
                    },
                    child:
                    ListTile(
                      leading:  Icon(
                        item.icon,
                        color: Colors.black,
                        size: 30.0,
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text(item.title) ],),
                      subtitle: Text("") ,
                      trailing:  Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.black,
                        size: 30.0,
                      ),
                      // isThreeLine: true,
                    ),
                  );
                }
            )));
  }
}

class ItemModel {
  // class constructor
  ItemModel(this.id, this.icon, this.title, this.pagename);

  // class fields
  final int id;
  final IconData icon;
  final String title;
  final String pagename;
}