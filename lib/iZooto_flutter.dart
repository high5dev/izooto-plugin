
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
export 'package:izooto_plugin/src/iZootoConnection.dart';
export 'package:izooto_plugin/iZooto_apns.dart';
enum OSInAppDisplayOption { None, InAppAlert, Notification }
typedef void ReceiveNotificationParam(String payload);
typedef void OpenedNotificationParam(String data);
typedef void TokenNotificationParam(String token);
typedef void WebViewNotificationParam(String landingUrl);

class iZooto {
  static iZooto shared = new iZooto();
  static const MethodChannel _channel = const MethodChannel('izooto_flutter');
  static ReceiveNotificationParam notificationReceiveData;
  static OpenedNotificationParam notificationOpenedData;
  static TokenNotificationParam notificationToken;
  static WebViewNotificationParam notificationWebView;
  iZooto() {
      _channel.setMethodCallHandler(handleOverrideMethod);
     // _channel.setMethodCallHandler(handleMethod);
  }

 // for integration ios
  static Future<void> iOSInit({
    @required String appId}) async {
    await _channel.invokeMethod('iOSInit', {
    'appId': appId
    });

  }
  static addUserProperties(String key, String value) async {
    _channel.invokeMethod('addUserProperties', {
      'key': key,
      'value': value,
    });
  }
  static setSubscription(bool enable) async {
    _channel.invokeMethod('iZootoSetSubscription', {'enable': enable});
  }

  static Future<String> receiveToken() async
  {
    final String receiveToken = await _channel.invokeMethod('onToken');
    return receiveToken;
  }
  static Future<String> receivePayload() async
  {
    final String receivePayload = await _channel.invokeMethod('receivePayload');
    return receivePayload;
  }
  static Future<String> receiveOpenData() async
  {
    final String receiveOpenData = await _channel.invokeMethod('openNotification');
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
  static Future<void> setNotificationSound(String soundName) async {
    await _channel.invokeMethod('notificationSound', soundName);
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

  void onNotificationReceived(ReceiveNotificationParam payload) {
    notificationReceiveData = payload;
    _channel.invokeMethod('receivedPayload');
  }

  void onNotificationOpened(OpenedNotificationParam data) {
    notificationOpenedData = data;
    _channel.invokeMethod('openNotification');
  }

  void onTokenReceived(TokenNotificationParam token) {
    notificationToken = token;
    _channel.invokeMethod('onToken');
  }

  void onWebView(WebViewNotificationParam landingUrl) {
    notificationWebView = landingUrl;
    _channel.invokeMethod('handleLandingURL');
  }


  Future<Null> handleOverrideMethod(MethodCall methodCall) async {
    if (methodCall.method == 'receivedPayload' &&
        notificationReceiveData != null) {

      notificationReceiveData(methodCall.arguments);
    } else if (methodCall.method == 'openNotification' &&
        notificationOpenedData != null) {
      notificationOpenedData(methodCall.arguments);
    } else if (methodCall.method == 'onToken' &&
        notificationToken != null) {
      notificationToken(methodCall.arguments);
    } else if (methodCall.method == 'handleLandingURL' &&
        notificationWebView != null) {
      notificationWebView(methodCall.arguments);
    }
  }






}
