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
  String _androidTag = 'iZooto Android -> ';
  String _iOSTag='iZooto iOS';

  Map<String, String> data;
  final PushConnector connector = createPushConnector();
  List<String> list, list2;

  Future<void> _iZootoInitialise() async {
/*
  Android Integration
 */
  iZooto.androidInit();
  iZooto.onNotificationOpened((data) {
    print(_androidTag+" Notification Click "+data);
  });

  iZooto.onTokenReceived((token) {
    print(_androidTag+" -> Token->"+token);
  });

  iZooto.onNotificationReceived((payload) {
    print(_androidTag +"Payload "+payload.title);

  });

  iZooto.onWebView((landingUrl) {
    print(_androidTag+"Landing URL "+landingUrl);
   // _launchInWebViewOrVC(landingUrl);
    // _navigateToNextScreen(context);
  });



/*
iOS Integration
 */


  iZooto.iOSInit(appId: "5f2f1dabe93b9f2329ead1bad063ec6ab6504766");
    final connector = this.connector;
    connector.configure(
      onLaunch: (data) => onPush('onLaunch', data),
      onResume: (data) => onPush('onResume', data),
      onMessage: (data) => onPush('onMessage', data),
      onBackgroundMessage: _onBackgroundMessage,
    );
    connector.token.addListener(() {
      print(_iOSTag+'Token ${connector.token.value}');
    });
    connector.receivePayload.addListener(() {
      print(_iOSTag+' ${connector.receivePayload.value}');
    });
    connector.openNotification.addListener(() {
      print(_iOSTag+' ${connector.openNotification.value}');
    });

    connector.openLandingURL.addListener(() {
      print(_iOSTag+' ${connector.openLandingURL.value}');
    });
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
              Text('Token:'),
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