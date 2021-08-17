import UIKit
import Flutter
import iZootoiOSSDK

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, iZootoNotificationOpenDelegate {
    func onNotificationOpen(action: Dictionary<String, Any>) {
        
        let jsonData = try! JSONSerialization.data(withJSONObject: action, options: [])
  let decoded = String(data: jsonData, encoding: .utf8)!
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let CHANNEL = FlutterMethodChannel(name: "iZooto-flutter", binaryMessenger: controller as! FlutterBinaryMessenger)
        CHANNEL.setMethodCallHandler{[unowned self](methodcall,result) in
            if(methodcall.method == "OpenNotification")
            {
               if(decoded != nil)
               {
                result(decoded)
               }
               else{
                result("")
               }
            }
            
    }
        
    }
    

    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    GeneratedPluginRegistrant.register(with: self)
    if launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] != nil {
     iZooto.notificationOpenDelegate = self
      
    }


    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        NSLog("PUSH registration failed: \(error)")
     }

}
