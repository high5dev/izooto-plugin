#import "IzootoPlugin.h"
#if __has_include(<izooto_plugin/izooto_plugin-Swift.h>)
#import <izooto_plugin/izooto_plugin-Swift.h>
#else
#import "izooto_plugin-Swift.h"
#endif
#import "iZootoiOSSDK/iZootoiOSSDK.h"

@implementation IzootoPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftIzootoPlugin registerWithRegistrar:registrar];
}
@end
