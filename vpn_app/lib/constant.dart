import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


const PRIVACY_TXT = "Free VPN does not collect personal information from you. \n\nWe do not keep logs of your online activites and never associate any domains or applications that you use with you, your device, IP address, or email.  \n\n For more information, please read our ";
const FONT_BOLD = "SkodaPro_Bold";
const FONT_COLOR1 = "#696969";
const Trial_txt = "By starting a 7-day free trial, you agree to the";
const ConnectImage = "assets/imgs/img2.png";
const DisConnectImage = "assets/imgs/img1.png";
const USFlag = "assets/imgs/flag.png";
const NetImg = "assets/imgs/net.png";

const String PRIVACY_POLICY_URL = "";
const String TERMS_CON_URL = "";

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}


class AppData {
  static final AppData _appData = new AppData._internal();

  bool isPro;

  factory AppData() {
    return _appData;
  }
  AppData._internal();
}

final appData = AppData();

const kColorPrimary = Color(0xff283149);
const kColorPrimaryLight = Color(0xff424B67);
const kColorPrimaryDark = Color(0xff21293E);
const kColorAccent = Colors.blue;
const kColorText = Color(0xffDBEDF3);





openUrl(String URL) async{
  if (await canLaunch(URL))
  await launch(URL);
  else
  // can't launch url, there is some error
  throw "Could not launch $URL";
}


showAlertDialog(BuildContext context){
  AlertDialog alert=AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 5),child:Text("Loading" )),
      ],),
  );
  showDialog(barrierDismissible: false,
    context:context,
    builder:(BuildContext context){
      return alert;
    },
  );
}

