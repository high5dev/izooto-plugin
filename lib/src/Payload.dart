import 'dart:convert';
import 'dart:core';

import 'dart:developer';

class Payload{
  String fetchURL;
  String key;
  String id;//campain id
  String rid;//run id
  String link;
  String title;
  String subTitle;
  String message;
  String icon;
  String badgeicon;
  String badgecolor;
  int group;
  int reqInt;
  String tag;
  String banner;
  int act_num;
  String act1name;
  String act1link;
  String act2name;
  String act2link;
  int inapp;
  String trayicon;
  String smallIconAccentColor;
  String sound;
  String ledColor;
  int lockScreenVisibility = 1;
  String groupKey;
  String groupMessage;
  String fromProjectNumber;
  String collapseId;
  int priority;
  String rawPayload;
  String act1ID;
  String act2ID;


  String ap;
  String type_input_to_payload;
  String dropdown_text;
  String validation;
  String editbox_title;
  String type;
  bool isAndroid;
  bool isiOS;
  bool isWeb;
  String  act1icon;
  String  act2icon;
  int  badgeCount;

  Payload(String payloadJson){
    log("iZootoData payloadJson "+payloadJson);

    Map<String, dynamic> map = jsonDecode(payloadJson) as Map<String, dynamic>; // import 'dart:convert';
    if(map.containsKey('title'))
      this.title = map['title'] as String;
    if(map.containsKey('message'))
      this.message = map['message'] as String;
    if(map.containsKey('fetchURL'))
      this.fetchURL = map['fetchURL'] as String;
    if(map.containsKey('icon'))
      this.icon = map['icon'] as String;
    if(map.containsKey('id'))
      this.id = map['id'] as String;
    if(map.containsKey('rid'))
      this.rid = map['rid'] as String;
    if(map.containsKey('link'))
      this.link = map['link'] as String;
    if(map.containsKey('subTitle'))
      this.subTitle = map['subTitle'] as String;
    if(map.containsKey('badgeicon'))
      this.badgeicon = map['badgeicon'] as String;
    if(map.containsKey('badgecolor'))
      this.badgecolor = map['badgecolor'] as String;
    if(map.containsKey('group'))
      this.group = map['group'] as int;
    if(map.containsKey('reqInt'))
      this.reqInt = map['reqInt'] as int;
    if(map.containsKey('tag'))
      this.tag = map['tag'] as String;
    if(map.containsKey('banner'))
      this.banner = map['banner'] as String;
    if(map.containsKey('act_num'))
      this.act_num = map['act_num'] as int;
    if(map.containsKey('act1name'))
      this.act1name = map['act1name'] as String;
    if(map.containsKey('act1link'))
      this.act1link = map['act1link'] as String;
    if(map.containsKey('act2name'))
      this.act2name = map['act2name'] as String;
    if(map.containsKey('act2link'))
      this.act2link = map['act2link'] as String;
    if(map.containsKey('inapp'))
      this.inapp = map['inapp'] as int;
    if(map.containsKey('trayicon'))
      this.trayicon = map['trayicon'] as String;
    if(map.containsKey('smallIconAccentColor'))
      this.smallIconAccentColor = map['smallIconAccentColor'] as String;
    if(map.containsKey('sound'))
      this.sound = map['sound'] as String;
    if(map.containsKey('ledColor'))
      this.ledColor = map['ledColor'] as String;
    if(map.containsKey('lockScreenVisibility'))
      this.lockScreenVisibility = map['lockScreenVisibility'] as int;
    if(map.containsKey('groupKey'))
      this.groupKey = map['groupKey'] as String;
    if(map.containsKey('groupMessage'))
      this.groupMessage = map['groupMessage'] as String;
    if(map.containsKey('fromProjectNumber'))
      this.fromProjectNumber = map['fromProjectNumber'] as String;
    if(map.containsKey('collapseId'))
      this.collapseId = map['collapseId'] as String;
    if(map.containsKey('priority'))
      this.priority = map['priority'] as int;
    if(map.containsKey('rawPayload'))
      this.rawPayload = map['rawPayload'] as String;
    if(map.containsKey('act1ID'))
      this.act1ID = map['act1ID'] as String;
    if(map.containsKey('act2ID'))
      this.act2ID = map['act2ID'] as String;
    if(map.containsKey('ap'))
      this.ap = map['ap'] as String;
    if(map.containsKey('type_input_to_payload'))
      this.type_input_to_payload = map['type_input_to_payload'] as String;
    if(map.containsKey('dropdown_text'))
      this.dropdown_text = map['dropdown_text'] as String;
    if(map.containsKey('validation'))
      this.validation = map['validation'] as String;
    if(map.containsKey('editbox_title'))
      this.editbox_title = map['editbox_title'] as String;
    if(map.containsKey('type'))
      this.type = map['type'] as String;
    if(map.containsKey('isAndroid'))
      this.isAndroid = map['isAndroid'] as bool;
    if(map.containsKey('isiOS'))
      this.isiOS = map['isiOS'] as bool;
    if(map.containsKey('isWeb'))
      this.isWeb = map['isWeb'] as bool;
    if(map.containsKey('act1icon'))
      this.act1icon = map['act1icon'] as String;
    if(map.containsKey('act2icon'))
      this.act2icon = map['act2icon'] as String;
    if(map.containsKey('badgeCount'))
      this.badgeCount = map['badgeCount'] as int;

  }

}