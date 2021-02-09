import Flutter
import UIKit
import iZootoiOSSDK
import UserNotifications

public class SwiftIzootoPlugin: NSObject, FlutterPlugin,UNUserNotificationCenterDelegate, iZootoNotificationReceiveDelegate, iZootoNotificationOpenDelegate, iZootoLandingURLDelegate {
    public func onNotificationOpen(action: Dictionary<String, Any>) {
      let jsonData = try! JSONSerialization.data(withJSONObject: action, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        channel.invokeMethod("onOpenNotification", arguments: decoded)
    }
    
    public func onHandleLandingURL(url: String) {
        channel.invokeMethod("onOpenLandingURL", arguments: url)
    }
    
    public func onNotificationReceived(payload: Payload) {

    }
    
    var launchNotification: [String: Any]?
    var resumingFromBackground = false

    static var loggingEnabled = false

    var channel = FlutterMethodChannel()
        
    internal init(channel: FlutterMethodChannel) {
           self.channel = channel
       }
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "izooto_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftIzootoPlugin(channel: channel)
    registrar.addApplicationDelegate(instance)

    registrar.addMethodCallDelegate(instance, channel: channel)

    let center = UNUserNotificationCenter.current()
           center.delegate = instance
      UNUserNotificationCenter.current().delegate = instance

  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    
    switch (call.method) {
    
    case "iZootoiOSInit":
        let map = call.arguments as? Dictionary<String, String>
                   let appId = map?["appId"]

        let iZootoInitSettings = ["auto_prompt": true,"nativeWebview": true,"provisionalAuthorization":false]
        UNUserNotificationCenter.current().delegate = self
        // initialisation
        iZooto.initialisation(izooto_id: appId!, application: UIApplication.shared,  iZootoInitSettings:iZootoInitSettings)
        iZooto.notificationReceivedDelegate = self
        iZooto.notificationOpenDelegate = self
        iZooto.landingURLDelegate = self
        
        break;
   
     case "getPlatformVersion":
        result("iOS " + UIDevice.current.systemVersion)
        break;
        
    case "addEvents":
       result("iOS " + UIDevice.current.systemVersion)
        let map = call.arguments as? Dictionary<String, String>
        let eventName = map?["eventName"]
        iZooto.addEvent(eventName: eventName!, data:map!)
       break;
    case "addUserProperties":
        let userPropertiesData = call.arguments as? Dictionary<String, String>
        let keyName = userPropertiesData?["key"]
        let valueName = userPropertiesData?["value"]
        let data = [keyName: valueName] as? [String : String]
        iZooto.addUserProperties(data: data!)
       break;
    case "setSubscription":
        let map = call.arguments as? Dictionary<String, Any>
        let enable: Bool = (map?["enable"] as? Bool)!
        print("Enable",enable)
        iZooto.setSubscription(isSubscribe: enable)
       break;
    default:
        result("Not Implemented")
        break;
    }
    
    
    
    
  }
    
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
        
        public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            iZooto.getToken(deviceToken: deviceToken)
            let tokenParts = deviceToken.map { data -> String in
                         return String(format: "%02.2hhx", data)
                     }
            let token = tokenParts.joined()
            channel.invokeMethod("onToken", arguments: token)
        }
        
        
        public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) -> Bool {
            
//            if resumingFromBackground {
//                onResume(userInfo: userInfo)
//            } else {
//                channel.invokeMethod("onMessage", arguments: userInfo)
//            }
//
            completionHandler(.noData)
            return true
        }
        
        public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            let userInfo = notification.request.content.userInfo
            let jsonData = try! JSONSerialization.data(withJSONObject: userInfo, options: [])
              let decoded = String(data: jsonData, encoding: .utf8)!
            channel.invokeMethod("onReceivedPayload", arguments: decoded)
            completionHandler([.alert])
        }
        
        public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            iZooto.notificationHandler(response: response)
            print("click")
            completionHandler()
        }
        
//        func onResume(userInfo: [AnyHashable: Any]) {
//            if let launchNotification = launchNotification {
//                channel.invokeMethod("onLaunch", arguments: userInfo)
//                self.launchNotification = nil
//                return
//            }
//
//            channel.invokeMethod("onResume", arguments: userInfo)
//        }
   
   
}
