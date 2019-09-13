#import "LiWebviewPlugin.h"
#import <li_webview/li_webview-Swift.h>

@implementation LiWebviewPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftLiWebviewPlugin registerWithRegistrar:registrar];
}
@end
