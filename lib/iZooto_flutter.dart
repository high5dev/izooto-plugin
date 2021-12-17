

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
export 'package:izooto_plugin/src/iZootoConnection.dart';
export 'package:izooto_plugin/iZooto_apns.dart';
enum OSInAppDisplayOption { None, InAppAlert, Notification }
typedef void ReceiveNotificationParam(String? payload);
typedef void OpenedNotificationParam(String? data);
typedef void TokenNotificationParam(String? token);
typedef void WebViewNotificationParam(String? landingUrl);
const  String PLUGIN_NAME ="izooto_flutter";
const String RECEIVE_PAYLOAD ="receivedPayload";//receivedPayload
const String ADDUSERPROPERTIES ="addUserProperties";
const String SETSUBSCRIPTION ="iZootoSetSubscription";
const String DEVICETOKEN="onToken";
const String DEEPLINKNOTIFICATION="openNotification";//openNotification
const String LANDINGURL="receiveLandingURL";
const String FIREBASEANALYTICS="iZootoFirebaseAnalytics";
const String ANDROIDINIT="iZootoAndroidInit";
const String NOTIFICATIONSOUND="notificationSound";
const String EVENTS="iZootoAddEvents";
const String PROPERTIES="iZootoAddProperties";
const String ADDTAG="iZootoAddTags";
const String REMOVETAG="iZootoRemoveTags";
const String HANDLENOTIFICATION="iZootoHandleNotification";
const String INAPPBEHAVIOUR="iZootoInAppNotificationBehaviour";
const String HANDLELANDINGURL="handleLandingURL";//handleLandingURL
const String NOTIFICATIONPREVIEW="izootoDefaultTemplate";
const String NOTIFICATIONBANNERIMAGE="izootoDefaultNotificationBanner";
const String ENABLE="enable";
const  String KEYEVENTNAME="eventName";
const  String KEYEVENTVALUE="eventValue";
const String iOSINIT="iOSInit";
const String iOSAPPID="appId";
const String FLUTTERSDKNAME="izooto_flutter";


// handle the text-overlay template
enum PushTemplate {DEFAULT, TEXT_OVERLAY}
class iZooto {
  static iZooto shared = new iZooto();
  static const MethodChannel _channel = const MethodChannel(FLUTTERSDKNAME);
  static ReceiveNotificationParam? notificationReceiveData;
  static OpenedNotificationParam? notificationOpenedData;
  static TokenNotificationParam? notificationToken;
  static WebViewNotificationParam? notificationWebView;


  iZooto() {
      _channel.setMethodCallHandler(handleOverrideMethod);
     // _channel.setMethodCallHandler(handleMethod);
  }

 // for integration ios
  static Future<void> iOSInit({
    required String appId}) async {
    await _channel.invokeMethod(iOSINIT, {
      iOSAPPID: appId
    });

  }
  static addUserProperties(String key, String value) async {
    _channel.invokeMethod(ADDUSERPROPERTIES, {
      'key': key,
      'value': value,
    });
  }
  static setSubscription(bool enable) async {
    _channel.invokeMethod(SETSUBSCRIPTION, {ENABLE: enable});
  }

  static Future<String?> receiveToken() async
  {
    final String? receiveToken = await _channel.invokeMethod(DEVICETOKEN);
    return receiveToken;
  }
  static Future<String?> receivePayload() async
  {
    final String? receivePayload = await _channel.invokeMethod(RECEIVE_PAYLOAD);
    return receivePayload;
  }
  static Future<String?> receiveOpenData() async
  {
    final String? receiveOpenData = await _channel.invokeMethod(DEEPLINKNOTIFICATION);
    return receiveOpenData;
  }
  static Future<String?> receiveLandingURL() async
  {
    final String? receiveLandingURL = await _channel.invokeMethod(LANDINGURL);
    return receiveLandingURL;
  }

  //start Android

  static Future<void> androidInit() async {
    await _channel.invokeMethod(ANDROIDINIT);
  }
  static Future<void> setFirebaseAnalytics(bool enable) async {
    await _channel.invokeMethod(FIREBASEANALYTICS, enable);
  }
  static Future<void> setNotificationSound(String soundName) async {
    await _channel.invokeMethod(NOTIFICATIONSOUND, soundName);
  }
  static Future<void> addEvent(String eventName,
      Map<String, Object> eventValue) async {
    await _channel.invokeMethod(
        EVENTS, {KEYEVENTNAME: eventName, KEYEVENTVALUE: eventValue});
  }
  static Future<void> addUserProperty(Map<String, Object> addValue) async {
    await _channel.invokeMethod(PROPERTIES, addValue);
  }
  static Future<void> addTag(List<String> topicName) async {
    await _channel.invokeMethod(ADDTAG, topicName);
  }

  static Future<void> removeTag(List<String> topicName) async {
    await _channel.invokeMethod(REMOVETAG, topicName);
  }

  static Future<void> handleNotification(dynamic data) async {
    await _channel.invokeMethod(HANDLENOTIFICATION,
        {HANDLENOTIFICATION: data});
  }

  static Future<void> setInAppNotificationBehaviour(
      OSInAppDisplayOption option) async {
    await _channel.invokeMethod(INAPPBEHAVIOUR,
        {INAPPBEHAVIOUR: option.index});
  }

  void onNotificationReceived(ReceiveNotificationParam payload) {
    notificationReceiveData = payload;
    _channel.invokeMethod(RECEIVE_PAYLOAD);
  }

  void onNotificationOpened(OpenedNotificationParam data) {
    notificationOpenedData = data;
    _channel.invokeMethod(DEEPLINKNOTIFICATION);
  }

  void onTokenReceived(TokenNotificationParam token) {
    notificationToken = token;
    _channel.invokeMethod(DEVICETOKEN);
  }

  void onWebView(WebViewNotificationParam landingUrl) {
    notificationWebView = landingUrl;
    _channel.invokeMethod(HANDLELANDINGURL);
  }
  static Future<void> setDefaultTemplate(
      PushTemplate option) async {
    await _channel.invokeMethod(NOTIFICATIONPREVIEW,
        {NOTIFICATIONPREVIEW: option.index});
  }

  static Future<void> setDefaultNotificationBanner(String setBanner) async {
    await _channel.invokeMethod(NOTIFICATIONBANNERIMAGE,
        {NOTIFICATIONBANNERIMAGE: setBanner});
  }

  Future<Null> handleOverrideMethod(MethodCall methodCall) async {
    if (methodCall.method == RECEIVE_PAYLOAD &&
        notificationReceiveData != null) {

      notificationReceiveData!(methodCall.arguments);
    } else if (methodCall.method == DEEPLINKNOTIFICATION &&
        notificationOpenedData != null) {
      notificationOpenedData!(methodCall.arguments);
    } else if (methodCall.method == DEVICETOKEN &&
        notificationToken != null) {
      notificationToken!(methodCall.arguments);
    } else if (methodCall.method == HANDLELANDINGURL &&
        notificationWebView != null) {
      notificationWebView!(methodCall.arguments);
    }
  }






}
