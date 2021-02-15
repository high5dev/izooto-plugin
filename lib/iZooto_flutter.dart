
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:izooto_plugin/src/Payload.dart';
export 'package:izooto_plugin/src/iZootoConnection.dart';
export 'package:izooto_plugin/iZooto_apns.dart';

enum OSInAppDisplayOption { None, InAppAlert, Notification }
typedef void ReceiveNotificationParam(Payload payload);
typedef void OpenedNotificationParam(String data);
typedef void TokenNotificationParam(String token);
typedef void WebViewNotificationParam(String landingUrl);

class iZooto{

  static const MethodChannel _channel = const MethodChannel('izooto_flutter');
  static ReceiveNotificationParam notificationReceiveData;
  static OpenedNotificationParam notificationOpenedData;
  static TokenNotificationParam notificationToken;
  static WebViewNotificationParam notificationWebView;

  iZooto() {
    _channel.setMethodCallHandler(handleOverrideMethod);
  }
 // for integration ios


  static Future<void> iOSInit({
    @required String appId}) async {
    await _channel.invokeMethod('iOSInit', {
    'appId': appId
    });

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

  //start Android

  static Future<void> androidInit() async {
    await _channel.invokeMethod('iZootoAndroidInit');
  }
  static Future<void> setFirebaseAnalytics(bool enable) async {
    await _channel.invokeMethod('iZootoFirebaseAnalytics', enable);
  }
  static Future<void> addEvent(String eventName,
      Map<String, Object> eventValue) async {
    await _channel.invokeMethod(
        'iZootoAddEvents', {'eventName': eventName, 'eventValue': eventValue});
  }
  static Future<void> addUserProperty(Map<String, Object> addValue) async {
    await _channel.invokeMethod('iZootoAddProperties', addValue);
  }
  static Future<void> addTag(List<String> topicName) async {
    await _channel.invokeMethod('iZootoAddTags', topicName);
  }

  static Future<void> removeTag(List<String> topicName) async {
    await _channel.invokeMethod('iZootoRemoveTags', topicName);
  }

  static Future<void> handleNotification(dynamic data) async {
    await _channel.invokeMethod('iZootoHandleNotification',
        {'iZootoHandleNotification': data});
  }

  static Future<void> setInAppNotificationBehaviour(
      OSInAppDisplayOption option) async {
    await _channel.invokeMethod('iZootoInAppNotificationBehaviour',
        {'iZootoInAppNotificationBehaviour': option.index});
  }

  static onNotificationReceived(ReceiveNotificationParam payload) {
    notificationReceiveData = payload;
    _channel.invokeMethod('receivedPayload');
  }

  static onNotificationOpened(OpenedNotificationParam data) {
    notificationOpenedData = data;
    _channel.invokeMethod('openNotification');
  }

  static onTokenReceived(TokenNotificationParam token) {
    notificationToken = token;
    _channel.invokeMethod('izooto_Notification_Token');
  }

  static onWebView(WebViewNotificationParam landingUrl) {
    notificationWebView = landingUrl;
    _channel.invokeMethod('handleLandingURL');
  }

  Future<Null> handleOverrideMethod(MethodCall methodCall) async {
    if (methodCall.method == 'receivedPayload' &&
        notificationReceiveData != null) {
      notificationReceiveData(Payload(methodCall.arguments));
    } else if (methodCall.method == 'openNotification' &&
        notificationOpenedData != null) {
      notificationOpenedData(methodCall.arguments);
    } else if (methodCall.method == 'iZootoNotificationToken' &&
        notificationToken != null) {
      notificationToken(methodCall.arguments);
    } else if (methodCall.method == 'handleLandingURL' &&
        notificationWebView != null) {
      notificationWebView(methodCall.arguments);
    }
  }
}
