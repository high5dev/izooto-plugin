import 'package:izooto_plugin/src/iZootoConnection.dart';
import 'package:izooto_plugin/src/iZootoiOS.dart';
PushConnector createPushConnector() {

    return iZootoiOS();

}