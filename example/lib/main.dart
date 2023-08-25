
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
      title: 'Flutter iOS Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(title: 'Flutter iZooto Plugin'),
      routes: {
        'pageTwo': (context) => PageTwo(),
      },
    );
  }
}

class Home extends StatefulWidget {
  final String title;

  Home({required this.title});

  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  static const platform = const MethodChannel("iZooto-flutter_webview");//iZooto-flutter_webview

  @override
  void initState() {
    super.initState();
    _iZootoInitialise();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const Center(
        child: Text(
          'Hello iZooto',
          style: TextStyle(color: Colors.green, fontSize: 20),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        autofocus: true,
        focusElevation: 5,
        child: const Icon(Icons.notifications),
        onPressed: () {
           iZooto.navigateToSettings(); // navigate to device notification setting page
        },
      ),
    );
  }

  //iZooto Integration
  Future<void> _iZootoInitialise() async {
     iZooto.androidInit(true); // for Android
     iZooto.promptForPushNotifications(); 
     iZooto.setNotificationChannelName(" Push Notification  "); // channel name
     iZooto.setDefaultTemplate(PushTemplate.TEXT_OVERLAY);
    if (Platform.isIOS) {
      iZooto.iOSInit(
          appId: "9f42c47c6d270255327c057ba31621cbd98ea12f"); // for iOS
    }
    // Received payload Android/iOS
    iZooto.shared.onNotificationReceived((payload) {
      print('iZooto Flutter Payload : $payload ');

      //List<dynamic> list = json.decode(payload);
     // print(list.toString());
     // List<String> receivedPayload = list.reversed.toList();
     // print(receivedPayload);
    });

    // DeepLink Android/iOS
    iZooto.shared.onNotificationOpened((data) {
      print('iZooto DeepLink Data : $data');
    //  Navigator.push(context,
         // MaterialPageRoute(builder: (context) => const SecondRoute()));
    });

    var feedData = await iZooto.getNotificationFeed(false);
    print('ABC $feedData');

    //LandingURLDelegate Android/iOS
    iZooto.shared.onWebView((landingUrl) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => PageTwo()));

      print('iZooto Landing URL  : $landingUrl');
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
       // Navigator.push(context,
           // MaterialPageRoute(builder: (context) => const SecondRoute()));
        //      Navigator.of(context).pushNamed('pageTwo');
      }
    } catch (Exception) {}

     try {
      String value = await platform.invokeMethod("handleLandingURL");
      if (value != null) {
        print('iZooto Killed state ios data : $value ');
       Navigator.push(context, MaterialPageRoute(builder: (context) => PageTwo()));
      }
    } catch (Exception) {}
  }
}

Future<dynamic> onPush(String name, Map<String, dynamic> payload) {
  return Future.value(true);
}

// Future<dynamic> _onBackgroundMessage(Map<String, dynamic> data) =>
//     onPush('onBackgroundMessage', data);
class PageTwo extends StatefulWidget {

  PageTwo();

  @override
  _PageTwoState createState() => new _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page 2"),
      ),
      body: Center(
        child: Text('Page Two'),
      ),
      floatingActionButton: FloatingActionButton(
        autofocus: true,
        focusElevation: 5,
        child: const Icon(Icons.notifications),
        onPressed: () {
           iZooto.navigateToSettings();
        },
      ),
    );
  }
}

// class SecondRoute extends StatelessWidget {
//   const SecondRoute();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Second Page'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: const Text('Go back!'),
//         ),
//       ),
//     );
//   }
// }