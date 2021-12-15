
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:izooto_plugin/iZooto_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(title: 'Flutter iZooto Plugin'),
      routes: {
        'pageTwo': (context) => PageTwo(title: 'Page Two'),
      },
    );
  }
}

class Home extends StatefulWidget {
  final String title;

  Home({Key key, this.title}) : super(key: key);

  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home>  {
  static const platform =const MethodChannel("iZooto-flutter");
  @override
  void initState() {
    super.initState();
    _iZootoInitialise();

  }
  @override
  void dispose() {
    super.dispose();
  }
  _showPasswordDialog(String data){
    showDialog(
        context: context,
        builder: (_){
          return AlertDialog(
            title: Text(data),
            content: Container(child: TextField(),),
            actions: <Widget>[FlatButton(child: Text("OK"),onPressed: (){},)],
          );
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: RaisedButton(
              child: Text('Unsubscrbe'),
            ),
          ),
          SizedBox(height: 16.0),
          Align(
            alignment: Alignment.center,
            child: RaisedButton(
              child: Text('Logout email'),
            ),
          )
        ],
      ),
    );
  }


    Future<void> _iZootoInitialise() async  {
/*
  iZooto Integration
 */

      iZooto.androidInit(); // for Android
      iZooto.setDefaultTemplate(PushTemplate.TEXT_OVERLAY);
      iZooto.setDefaultNotificationBanner("");
      if(Platform.isIOS) {
        iZooto.iOSInit(
            appId: "5f2f1dabe93b9f2329ead1bad063ec6ab6504766"); // for iOS
      }
     // DeepLink Android/iOS
      iZooto.shared.onNotificationOpened((data) {
            print('iZooto DeepLink Datadata : $data');
      });
      // LandingURLDelegate Android/iOS
      iZooto.shared.onWebView((landingUrl) {
        print(landingUrl);
        print('iZooto Landing URL  : $landingUrl');

      });

     // Received paylaod Android/iOS
      iZooto.shared.onNotificationReceived((payload) {
        print('iZooto Flutter Paylaod : $payload ');

        List<dynamic> list = json.decode(payload);
        print(list.toString());
        List<String> receivedpayload = list.reversed.toList();

        print(receivedpayload);
      });
      // Device token Android/iOS
      iZooto.shared.onTokenReceived((token) {
        print('iZooto Flutter Token : $token ');
      });
      //iOS DeepLink Killed state code
      try {
        String value = await platform.invokeMethod("OpenNotification");
        if (value != null) {
          print('iZooto Killed state ios data : $value ');

          Navigator.of(context).pushNamed('pageTwo');
        }
      } catch(Exception) {}



    }


}

Future<dynamic> onPush(String name, Map<String, dynamic> payload) {
  return Future.value(true);
}
Future<dynamic> _onBackgroundMessage(Map<String, dynamic> data) =>
    onPush('onBackgroundMessage', data);




class PageTwo extends StatefulWidget {
  final String title;

  PageTwo({Key key, this.title}) : super(key: key);

  @override
  _PageTwoState createState() => new _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text('Page two'),
      ),
    );
  }
}