import 'dart:io';

import 'package:izooto_plugin/iZooto_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:async';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String _Tag='iZooto Flutter Plugin ->';
  final PushConnector connector = createPushConnector();
  Future<void> _iZootoInitialise() async {
/*
  iZooto Integration
 */
  iZooto.androidInit(); // for Android
  iZooto.setSubscription(true);
  // NOTE: Replace with your own app ID
  iZooto.iOSInit(appId: "5f2f1dabe93b9f2329ead1bad063ec6ab6504766"); // for iOS
    final connector = this.connector;
    connector.configure(
      onLaunch: (data) => onPush('onLaunch', data),
      onResume: (data) => onPush('onResume', data),
      onMessage: (data) => onPush('onMessage', data),
      onBackgroundMessage: _onBackgroundMessage,
    );
    connector.token.addListener(() {
      print(_Tag+'Token : ${connector.token.value}');
    });
    connector.receivePayload.addListener(() {
      print(_Tag+' Payload : ${connector.receivePayload.value}');
    });
    connector.openNotification.addListener(() {
      print(_Tag+'Notification Tap : ${connector.openNotification.value}');
    });

    connector.openLandingURL.addListener(() {
      print(_Tag+'Landing URL : ${connector.openLandingURL.value}');
    });
    iZooto.onNotificationOpened((data) {
      print("Data--->"+data);
    });
    /*

        iZooto.addEvent('flutterplugin16', {'Sports':'cricket'});
        iZooto.addUserProperty({'Language':'English '});
        iZooto.setSubscription(false);
        iZooto.setFirebaseAnalytics(true);

        List<String> list , list2;
        list = ['Football'];
        list2 =['Chocolate'];
        iZooto.addTag(list);
        iZooto.removeTag(list2);
     */












  }

  @override
  void initState() {

    _iZootoInitialise();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('iZooto Plugin Example'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(' Device Token:'),
              ValueListenableBuilder(
                 valueListenable: connector.token,
                builder: (context, data, __) {
                  return SelectableText('$data');
                },
              )
            ],
          ),
        ),
      ),
    );
  }

}

Future<dynamic> onPush(String name, Map<String, dynamic> payload) {



  return Future.value(true);
}

Future<dynamic> _onBackgroundMessage(Map<String, dynamic> data) =>
    onPush('onBackgroundMessage', data);