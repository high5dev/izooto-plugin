import 'dart:async';
import 'package:izooto_plugin/src/iZootoApnsPushController.dart';
import 'package:izooto_plugin/src/iZootoConnector.dart';
PushConnector createPushConnector() {

    return iZootoApnsPushConnector();

}