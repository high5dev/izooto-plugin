import UIKit
import Flutter
import iZootoiOSSDK

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, iZootoNotificationOpenDelegate,iZootoLandingURLDelegate {
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
    /* Handle the webview listener */
    func onHandleLandingURL(url: String) {
          
          let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
          let CHANNEL = FlutterMethodChannel(name: "iZooto-flutter_webview", binaryMessenger: controller as! FlutterBinaryMessenger)
          
          CHANNEL.setMethodCallHandler{[unowned self](methodcall,result) in
              
              if (methodcall.method == "handleLandingURL"){
                  if url != "" {
                      alert()

                      result(url)
                  }else{
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
          iZooto.landingURLDelegate = self
//          guard let options = launchOptions,
//                let remoteNotif = options[UIApplication.LaunchOptionsKey.remoteNotification] as? [String: Any]
//          else
//          {
//              return
//          }
//      
//          let aps = remoteNotif["aps"] as? [String: Any]
//          NSLog("\n Custom: \(String(describing: aps))")
//        alert()

    }
      iZooto.landingURLDelegate = self

//      else
//      {
//          alert()
//
//      }
      


    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    func alert()
    {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                   self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                   let alert = UIAlertController(title: "", message: "Alert just at launch", preferredStyle: .alert)
                   self.window?.rootViewController?.present(alert, animated: true, completion: nil)
               }
    }
    override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        NSLog("PUSH registration failed: \(error)")
     }

}
