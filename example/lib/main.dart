import 'package:izooto_plugin/IzootoPlugin.dart';
import 'package:izooto_plugin/iZooto_flutter_apns.dart';
import 'package:flutter/material.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final PushConnector connector = createPushConnector();

  Future<void> _iZootoInitialise() async {
    IzootoPlugin.iZootoiOSInit(appId: "5f2f1dabe93b9f2329ead1bad063ec6ab6504766");

    final connector = this.connector;
    connector.configure(
      onLaunch: (data) => onPush('onLaunch', data),
      onResume: (data) => onPush('onResume', data),
      onMessage: (data) => onPush('onMessage', data),
      onBackgroundMessage: _onBackgroundMessage,
    );
    connector.token.addListener(() {
      print('Token ${connector.token.value}');
    });
    connector.receivePayload.addListener(() {
      print('Receivedpayload ${connector.receivePayload.value}');
    });
    connector.openNotification.addListener(() {
      print('OpenNotification ${connector.openNotification.value}');
    });

    connector.openLandingURL.addListener(() {
      print('LandingURL ${connector.openLandingURL.value}');
    });

    // for subscription
   // IzootoPlugin.setSubscription(false);
    IzootoPlugin.addUserProperties("Language", "Punjabi");


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