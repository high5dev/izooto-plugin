//
//  NotificationService.swift
//  FlutteriZootoNotificationSextesnionServices
//
//  Created by Amit on 16/07/21.
//

import UserNotifications
import iZootoiOSSDK
class NotificationService: UNNotificationServiceExtension {
  var contentHandler: ((UNNotificationContent) -> Void)?
  var bestAttemptContent: UNMutableNotificationContent?
  var receivedRequest: UNNotificationRequest!
  override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
    print("Response",request)
      self.receivedRequest = request;
      self.contentHandler = contentHandler
      bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
      if let bestAttemptContent = bestAttemptContent {
        iZooto.didReceiveNotificationExtensionRequest(bundleName :"YOUR_BUNDLE_IDENTIFIER_NAME",request: receivedRequest, bestAttemptContent: bestAttemptContent,contentHandler: contentHandler)
    }
    }
    override func serviceExtensionTimeWillExpire() {
      if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
        contentHandler(bestAttemptContent)
      }
    }
}
