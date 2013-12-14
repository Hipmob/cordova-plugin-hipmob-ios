#import <Cordova/CDV.h>

@interface HipmobPlugin : CDVPlugin

- (void)openChat:(CDVInvokedUrlCommand*)command;

- (void)openHelpdeskSearch:(CDVInvokedUrlCommand*)command;

- (void)openHelpdeskArticle:(CDVInvokedUrlCommand*)command;

@end
