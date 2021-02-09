#import "IzootoPlugin.h"
#if __has_include(<izooto_plugin/izooto_plugin-Swift.h>)
#import <izooto_plugin/izooto_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "izooto_plugin-Swift.h"
#endif

@implementation IzootoPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftIzootoPlugin registerWithRegistrar:registrar];
}
@end
