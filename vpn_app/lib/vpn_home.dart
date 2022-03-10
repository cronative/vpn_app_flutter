import 'package:flutter/material.dart';
import 'constant.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'server_locations.dart';
import 'settings.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:flutter_vpn/flutter_vpn.dart';




class VpnHome extends StatefulWidget {
  @override
  _VpnHomeState createState() => _VpnHomeState();
}

class _VpnHomeState extends State<VpnHome> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  var isConnect = false;
  String connectButtonTxt = "CONNECT";
  final LocalStorage storage = new LocalStorage('VPN');
  List _servers = [];
  var bottomSheetController;
  Map<String,dynamic> _selectedItem;
  var state = FlutterVpnState.disconnected;

  @override
  void initState() {

    // print('Platform $Platform');

    _controller = AnimationController(vsync: this);
    super.initState();

    var _selectedServerItem = storage.getItem('_selectedServerItem');
    print('_selectedServerItem $_selectedServerItem');

setState(() {
  _selectedItem = _selectedServerItem;
});
    // if (Platform.isAndroid || Platform.isIOS) {
      // Android-specific code
      FlutterVpn.prepare();
      FlutterVpn.onStateChanged.listen((s) {
        if (s == FlutterVpnState.connected) {
          // Device Connected
          print('Device is Connected');
          isConnect = true;
        }
        if (s == FlutterVpnState.disconnected) {
          // Device Disconnected
          isConnect = false;
          print('Device is Disconnected');
        }
        setState(() {
          state = s;

        });
      });
    // } else {
    //
    // }



    print('selectedItem $_selectedItem');
    // getServerData();

  }

  void connectVpn() {
    if (state == FlutterVpnState.connected) {
      FlutterVpn.disconnect();
    } else {
      FlutterVpn.simpleConnect(
          _selectedItem["server_ip"], "tensai", "tensai321@");
    }
    print("connect");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future getServerData() async {
    showAlertDialog(context);
    var accessToken = storage.getItem('access_token');
    print('accessToken $accessToken');
    http.Response response = await http.get(
      "http://ec2-54-215-101-89.us-west-1.compute.amazonaws.com/api/servers",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':'Bearer $accessToken'
      },
    );

    var r = jsonDecode(response.body);
    print('Login response  $r');
    setState(() {
      _servers = r["server"];
      Navigator.pop(context);
      if(_servers.isNotEmpty){
        // _selectedItem = _servers[0];

        showLocationList();
        print(_selectedItem);
      }
    });
  }

  // callback function
  VoidCallback onSelectItem() {
    print('onSelectItem');
    setState(() {
      // count++;
    });
  }

  showLocationList(){
    bottomSheetController = showMaterialModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => new Container(
        height: 500.0,
        color: Colors.transparent, //could change this to Color(0xFF737373),
        //so you don't have to change MaterialApp canvasColor
        child: ServerLocations(servers: _servers, callBack:(Map<String, dynamic> selectedItem){
          print(selectedItem);
          setState(() {
            _selectedItem = selectedItem;
            
          });

          Navigator.of(context).pop();
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
  backgroundColor: Colors.white,
  elevation: 0.0,
),
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
                    padding: EdgeInsets.only(top: 0, left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [ Image(
                              height: 50,
                              image: AssetImage('assets/imgs/firevpn.png')),
                            new IconButton(
                                  icon: Icon(Icons.settings),
                                  color: Colors.red,
                                  iconSize:40,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Settings()),
                                    );
                                  },
                                ),

                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 130),
                          child: Image(
                              // height: 50,
                              image: AssetImage(isConnect ? ConnectImage : DisConnectImage)),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: ButtonTheme(
                              minWidth: 300.0,
                              height: 50.0,
                              child: RaisedButton(
                                onPressed: () {
                                  connectVpn();
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    ),
                                child:  Text(isConnect ? "DISCONNECT" : "CONNECT",
                                    style: TextStyle(fontSize: 20)),
                                color: isConnect ? Colors.red : Colors.grey,
                                textColor: Colors.white,
                                elevation: 0.0,
                              ),
                            )),
                        Padding(
                            padding: EdgeInsets.only(top: 50,left: 50,right: 50),
                            child: Center(child:  ButtonTheme(
                              minWidth: 300.0,
                              height: 50.0,
                              child: RaisedButton(
                                onPressed: () {
                                  getServerData();
                                  // bottomSheetController = showMaterialModalBottomSheet(
                                  //   context: context,
                                  //   backgroundColor: Colors.transparent,
                                  //   builder: (context) => new Container(
                                  //     height: 500.0,
                                  //     color: Colors.transparent, //could change this to Color(0xFF737373),
                                  //     //so you don't have to change MaterialApp canvasColor
                                  //     child: ServerLocations(servers: _servers, callBack:(Map<String, dynamic> selectedItem){
                                  //       print(selectedItem);
                                  //       setState(() {
                                  //         _selectedItem = selectedItem;
                                  //       });
                                  //
                                  //       Navigator.of(context).pop();
                                  //     }),
                                  //   ),
                                  // );
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                child:  Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image(
                                      // height: 50,
                                        image: AssetImage(USFlag)),
                                    Padding(padding: EdgeInsets.only(left: 10), child: Text(_selectedItem != null? _selectedItem['server_name']: ''),),
                                    Padding(padding: EdgeInsets.only(left: 10), child: Image(
                                      // height: 50,
                                        image: AssetImage(NetImg)),),
                                    Padding(padding: EdgeInsets.only(left: 10), child:  Icon(
                                      Icons.keyboard_arrow_up,
                                      color: Colors.black,
                                      size: 30.0,
                                    ))
                                  ],),
                                color:  Colors.white,
                                // textColor: Colors.white,
                                elevation: 0.0,
                              ),
                            ))),
                      ],
                    )),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   mainAxisSize: MainAxisSize.max,
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: <Widget>[
                //     //your elements here
                //     Padding(
                //         padding: EdgeInsets.only(bottom: 150,left: 50,right: 50),
                //         child: Center(child:  ButtonTheme(
                //           minWidth: 300.0,
                //           height: 50.0,
                //           child: RaisedButton(
                //             onPressed: () {
                //               showMaterialModalBottomSheet(
                //                 context: context,
                //                 backgroundColor: Colors.transparent,
                //                 builder: (context) => new Container(
                //                   height: 500.0,
                //                   color: Colors.transparent, //could change this to Color(0xFF737373),
                //                   //so you don't have to change MaterialApp canvasColor
                //                   child: ServerLocations(),
                //                 ),
                //               );
                //             },
                //             shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(25.0),
                //             ),
                //             child:  Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //               children: [
                //
                //               Image(
                //                 // height: 50,
                //                   image: AssetImage(USFlag)),
                //               Padding(padding: EdgeInsets.only(left: 10), child: Text("Los Angeles"),),
                //               Padding(padding: EdgeInsets.only(left: 10), child: Image(
                //                 // height: 50,
                //                   image: AssetImage(NetImg)),),
                //               Padding(padding: EdgeInsets.only(left: 10), child:  Icon(
                //                 Icons.keyboard_arrow_up,
                //                 color: Colors.black,
                //                 size: 30.0,
                //               ))
                //             ],),
                //             color:  Colors.white,
                //             // textColor: Colors.white,
                //             elevation: 0.0,
                //           ),
                //         ))),
                //   ],
                // ),
              ],
            )));
  }
}
