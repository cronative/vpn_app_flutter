import 'package:flutter/material.dart';
import 'constant.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

typedef OnSelectItemCallBack = void Function(Map<String, dynamic> selectedItem);

class ServerLocations extends StatefulWidget {
  @override
  _ServerLocationsState createState() => _ServerLocationsState();

  ServerLocations({Key key, this.servers,this.callBack}) : super(key: key);
  final List servers;
  final OnSelectItemCallBack callBack;
}

class _ServerLocationsState extends State<ServerLocations>
    with SingleTickerProviderStateMixin {
  bool isVisible = false;
  final LocalStorage storage = new LocalStorage('VPN');

  // List _servers;

  @override
  void initState() {
    super.initState();
    // getServerData();
    var s = widget.servers;
    print('_servers $s');
  }

  final List<ItemModel> _items = [
    ItemModel(0, Icons.account_balance, 'Balance', 'Some info'),
    ItemModel(1, Icons.account_balance_wallet, 'Balance wallet', 'Some info'),
    ItemModel(2, Icons.alarm, 'Alarm', 'Some info'),
    ItemModel(3, Icons.my_location, 'My location', 'Some info'),
    ItemModel(4, Icons.laptop, 'Laptop', 'Some info'),
    ItemModel(5, Icons.backup, 'Backup', 'Some info'),
    ItemModel(6, Icons.settings, 'Settings', 'Some info'),
    ItemModel(7, Icons.call, 'Call', 'Some info'),
    ItemModel(8, Icons.restore, 'Restore', 'Some info'),
    ItemModel(9, Icons.camera_alt, 'Camera', 'Some info'),
  ];

  // Future getServerData() async {
  //   var accessToken = storage.getItem('access_token');
  //   print('accessToken $accessToken');
  //   http.Response response = await http.get(
  //     "http://ec2-54-215-101-89.us-west-1.compute.amazonaws.com/api/servers",
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'Authorization':'Bearer $accessToken'
  //     },
  //   );
  //
  //   var r = jsonDecode(response.body);
  //   print('Login response  $r');
  //   setState(() {
  //     _servers = r["server"];
  //   });
  //
  //   print('_servers response  $_servers');
  //   // storage.setItem('access_token', at);
  //   if (response.statusCode == 201) {
  //     print('Login response  $response');
  //     // If the server did return a 201 CREATED response,
  //     // then parse the JSON.
  //     // return Album.fromJson(jsonDecode(response.body));
  //   } else {
  //     // If the server did not return a 201 CREATED response,
  //     // then throw an exception.
  //     // throw Exception('Failed to load album');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return new Container(
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0))),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10, top: 20),
                child: Text(
                  'Server Locations',
                  style: TextStyle(fontSize: 22),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(right: 10, top: 20),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black,
                    size: 30.0,
                  )),
            ],
          ),
          Expanded(
              child: ListView.builder(
                  // Let the ListView know how many items it needs to build.
                  itemCount: widget.servers.length,
                  // Provide a builder function. This is where the magic happens.
                  // Convert each item into a widget based on the type of item it is.
                  itemBuilder: (context, index) {
                    final item = widget.servers[index];
                    return InkWell(
                      // Enables taps for child and add ripple effect when child widget is long pressed.
                      onTap:
                        () {
                          widget.callBack(item);
                        // Navigator.of(context).pop('value');
                      },
                      child: ListTile(
                        leading: Image(
                            // height: 50,
                            image: AssetImage(USFlag)),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item['server_name']),
                            Image.asset(NetImg)
                          ],
                        ),
                        trailing: Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.black,
                          size: 30.0,
                        ),
                        // isThreeLine: true,
                      ),
                    );
                  }))
        ]));
  }
}

class ItemModel {
  // class constructor
  ItemModel(this.id, this.icon, this.title, this.description);

  // class fields
  final int id;
  final IconData icon;
  final String title;
  final String description;
}
