
import 'package:flutter/services.dart';
import 'package:izooto_plugin/iZooto_apns.dart';
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
  static const platform =const MethodChannel("izooto-flutter");

  String _Tag='iZooto Flutter Plugin ->';
  PushConnector connector = createPushConnector();

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
      iZooto.iOSInit(
          appId: "5f2f1dabe93b9f2329ead1bad063ec6ab6504766"); // for iOS
      iZooto.shared.onNotificationOpened((data) {
         //   _showPasswordDialog(data);
            print(data);
      });
      iZooto.setNotificationSound("abc");
      iZooto.shared.onWebView((landingUrl) {
      //  _showPasswordDialog(landingUrl);
        print(landingUrl);
      });
      iZooto.shared.onNotificationReceived((payload) {
       // _showPasswordDialog(payload);
        List<dynamic> list = json.decode(payload);
        print(list.toString());
        List<String> reversedAnimals = list.reversed.toList();

        print(reversedAnimals);
      });
      iZooto.shared.onTokenReceived((token) {
        print('Flutter : $token ');
      });


      // final connector = this.connector;
      // connector.configure(
      //
      //     onLaunch: (data) => onPush('onLaunch', data),
      //   onResume: (data) => onPush('onResume', data),
      //   onMessage: (data) => onPush('onMessage', data),
      //   onBackgroundMessage: _onBackgroundMessage,
      // );
      // try {
      //   String value = await platform.invokeMethod("OpenNotification");
      //   if (value != null) {
      //     _showPasswordDialog(value);
      //     Navigator.of(context).pushNamed('pageTwo');
      //   }
      // }catch(Exception){}
      // connector.token.addListener(() {
      //   print(_Tag + 'Token : ${connector.token.value}');
      // });
      // connector.receivePayload.addListener(() {
      //   print(_Tag + ' Payload : ${connector.receivePayload.value}');
      // });
      // connector.openNotification.addListener(() {
      //   Navigator.of(context).pushNamed('pageTwo');
      //   print(_Tag + 'Notification Tap : ${connector.openNotification.value}');
      // });
      // connector.openLandingURL.addListener(() {
      //   Navigator.of(context).pushNamed('pageTwo');
      //   print(_Tag + 'Landing URL : ${connector.openLandingURL.value}');
      // });

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