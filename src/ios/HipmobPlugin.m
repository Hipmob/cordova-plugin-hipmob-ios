#import "HipmobPlugin.h"
#import <Cordova/CDV.h>

@implementation MyPlugin

- (void)openChat:(CDVInvokedUrlCommand*)command
{
  NSString * appid = [command.arguments objectAtIndex:0];
  
  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Hello - that's your plugin :)"];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)openHelpdeskSearch:(CDVInvokedUrlCommand*)command
{
  NSString * appid = [command.arguments objectAtIndex:0];
  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Hello - that's your plugin :)"];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)openHelpdeskArticle:(CDVInvokedUrlCommand*)command
{
  NSString * appid = [command.arguments objectAtIndex:0];
  NSString * articleurl = [command.arguments objectAtIndex:1];
  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Hello - that's your plugin :)"];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
@end
