import 'package:flutter/foundation.dart';

/// Function signature for callbacks executed when push message is available;
typedef Future<void> MessageHandler(Map<String, dynamic> message);

/// Interface for either APNS or Firebase connector, implementing common features.
abstract class PushConnector {
  /// User declined to allow for push messages.
  /// initially nil
  ValueNotifier<bool> get isDisabledByUser;

  /// Value of registered token
  /// initially nil
  ValueNotifier<String> get token;

  ValueNotifier<String> get receivePayload;

  ValueNotifier<String> get openNotification;

  ValueNotifier<String> get openLandingURL;

  /// Either GCM or APNS
  String get providerType;

  /// Configures callbacks for supported message situations.
  void configure({
    /// iOS only: return true to display notification while app is in foreground
    MessageHandler onMessage,
    MessageHandler onLaunch,
    MessageHandler onResume,

    MessageHandler onBackgroundMessage,
  });

  /// Prompts (if need) the user to enable push notifications.
  /// After user makes their choice, isDisabledByUser will become either true or false.
  /// If accepted, token.value will be set
  void requestNotificationPermissions();

  /// Unregisters from the service and clears the token.
  Future<void> unregister();

  /// Deletes used resources.
  void dispose() {}
}