
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class IzootoPlugin {
  static const MethodChannel _channel =
      const MethodChannel('izooto_plugin');
  static Future<bool> iZootoiOSInit({
    @required String appId


  }) async {
    var notificationPermissionGranted =
    await _channel.invokeMethod('iZootoiOSInit', {
    'appId': appId
    });

    return notificationPermissionGranted;
  }
  static addUserProperties(String key, String value) {
    _channel.invokeMethod('addUserProperties', {
      'key': key,
      'value': value,
    });
  }
  static setSubscription(bool enable) {
    _channel.invokeMethod('setSubscription', {'enable': enable});
  }
  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
  static Future<String> receiveToken() async
  {
    final String receiveToken = await _channel.invokeMethod('receiveToken');
    return receiveToken;
  }
  static Future<String> receivePayload() async
  {
    final String receivePayload = await _channel.invokeMethod('receivePayload');
    return receivePayload;
  }
  static Future<String> receiveOpenData() async
  {
    final String receiveOpenData = await _channel.invokeMethod('receiveOpenData');
    return receiveOpenData;
  }
  static Future<String> receiveLandingURL() async
  {
    final String receiveLandingURL = await _channel.invokeMethod('receiveLandingURL');
    return receiveLandingURL;
  }


}
