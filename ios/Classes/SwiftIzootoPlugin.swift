import Flutter
import UIKit
import iZootoiOSSDK
import UserNotifications
@objc public class SwiftIzootoPlugin: NSObject, FlutterPlugin,UNUserNotificationCenterDelegate, iZootoNotificationOpenDelegate, iZootoLandingURLDelegate {
    
    static var data = "";
   
    internal init(channel: FlutterMethodChannel) {
           self.channel = channel
       }
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "izooto_flutter", binaryMessenger: registrar.messenger())
   

    let instance = SwiftIzootoPlugin(channel: channel)
    registrar.addApplicationDelegate(instance)
    registrar.addMethodCallDelegate(instance, channel: channel)
    let center = UNUserNotificationCenter.current()
           center.delegate = instance
    

  }
    public func onNotificationOpen(action: Dictionary<String, Any>) {
                    let jsonData = try! JSONSerialization.data(withJSONObject: action, options: [])
              let decoded = String(data: jsonData, encoding: .utf8)!
            self.channel.invokeMethod("openNotification", arguments: decoded)
              
    }
    
    public func onHandleLandingURL(url: String) {
        self.channel.invokeMethod("handleLandingURL", arguments: url)
    }
    
//    public func onNotificationReceived(payload: Payload) {
//
//    }
    var channel = FlutterMethodChannel()
    var launchNotification: [String: Any]?
    var resumingFromBackground = false
    static var loggingEnabled = false
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    
    switch (call.method) {
    
    case "iOSInit":
        let map = call.arguments as? Dictionary<String, String>
        let appId = map?["appId"]
        let iZootoInitSettings = ["auto_prompt": true,"nativeWebview": true,"provisionalAuthorization":false]
        iZooto.initialisation(izooto_id: appId!, application: UIApplication.shared,  iZootoInitSettings:iZootoInitSettings)
        iZooto.notificationOpenDelegate = self
        iZooto.landingURLDelegate = self
        UNUserNotificationCenter.current().delegate = self
        iZooto.setPluginVersion(pluginVersion: "fv_2.1.2")

        break;
   
     case "getPlatformVersion":
        result("iOS " + UIDevice.current.systemVersion)
        break;
        
    case "addEvents":
        let map = call.arguments as? Dictionary<String, String>
        let eventName = map?["eventName"]
        iZooto.addEvent(eventName: eventName!, data:map!)
       break;
    case "addUserProperties":
        let userPropertiesData = call.arguments as? Dictionary<String, String>
       // print(userPropertiesData)
        let keyName = userPropertiesData?["key"]
        let valueName = userPropertiesData?["value"]
        let data = [keyName: valueName] as? [String : String]
        iZooto.addUserProperties(data: data!)
       break;
    case "setSubscription":
        let map = call.arguments as? Dictionary<String, Any>
        let enable: Bool = (map?["enable"] as? Bool)!
        iZooto.setSubscription(isSubscribe: enable)
       break;
    default:
        result("Not Implemented")
        break;
    }
    
  }
   
    // appDelegate integration
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable : Any] = [:]) -> Bool {
      
        launchNotification = launchOptions[UIApplication.LaunchOptionsKey.remoteNotification] as? [String: Any]
            
            return true
        }
        
        public func applicationDidEnterBackground(_ application: UIApplication) {
            resumingFromBackground = true

        }
        
        public func applicationDidBecomeActive(_ application: UIApplication) {
            resumingFromBackground = false
            application.applicationIconBadgeNumber = 1
            application.applicationIconBadgeNumber = 0
        }
        //handle token
        public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            iZooto.getToken(deviceToken: deviceToken)
            let tokenParts = deviceToken.map { data -> String in
                         return String(format: "%02.2hhx", data)
                     }
            let token = tokenParts.joined()
           // print(token)
                // channel.invokeMethod("onToken", arguments: token)
            channel.invokeMethod("onToken", arguments: token)
        }
        
        
        public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) -> Bool {
//
//            if resumingFromBackground {
//                onResume(userInfo: userInfo)
//            } else {
//                channel.invokeMethod("onMessage", arguments: userInfo)
//            }
//            completionHandler(.newData)
            return true
        }
        // called forground
        public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            let userInfo = notification.request.content.userInfo
            let jsonData = try! JSONSerialization.data(withJSONObject: userInfo, options: [])
              let decoded = String(data: jsonData, encoding: .utf8)!
            channel.invokeMethod("receivedPayload", arguments: decoded)
            iZooto.handleForeGroundNotification(notification: notification, displayNotification: "NONE", completionHandler:completionHandler)
            completionHandler([.alert])
        }
        // called background
        public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            let userInfo = response.notification.request.content.userInfo
            let jsonData = try! JSONSerialization.data(withJSONObject: userInfo, options: [])
              let decoded = String(data: jsonData, encoding: .utf8)!
             channel.invokeMethod("receivedPayload", arguments: decoded);
            
            iZooto.notificationHandler(response: response)
            
            completionHandler()
        }
 
        func onResume(userInfo: [AnyHashable: Any]) {
            if launchNotification != nil {
                channel.invokeMethod("onResume", arguments: userInfo)
                self.launchNotification = nil
                return
            }
           // iZooto.notificationOpenDelegate=self
            channel.invokeMethod("onResume", arguments: userInfo)
        }
    
  
}
