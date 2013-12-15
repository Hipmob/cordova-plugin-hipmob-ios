#import "HipmobPlugin.h"
#import "HMChatViewController.h"
#import "HMHelpDeskSearchViewController.h"
#import "HMHelpDeskArticleViewController.h"

@implementation HipmobPlugin

+ (UIColor *) colorFromHexString:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (void)openChat:(CDVInvokedUrlCommand*)command
{
    NSString * appid = (NSString *)[command.arguments objectAtIndex:0];
    NSDictionary * options = [command.arguments objectAtIndex:1];
    NSString * userid = [options objectForKey:@"user"];
    NSString * val = [options objectForKey:@"peer"];
    HMChatViewController * livechat = nil;
    if(val == nil) livechat = [[HMChatViewController alloc] initWithAppID:appid andUser:userid];
    else livechat = [[HMChatViewController alloc] initWithAppID:appid andUser:userid andPeer:val];
    
    // title bar color
    val = [options objectForKey:@"titlebarcolor"];
    if(val){
        if([livechat.navigationBar respondsToSelector:@selector(barTintColor)]){
            livechat.navigationBar.barTintColor = colorFromHexString(val);
            livechat.navigationBar.translucent = FALSE;
        }else{
            livechat.navigationBar.tintColor = colorFromHexString(val);
        }
    }
    
    // title
    livechat.body.title = (val = [options objectForKey:@"title"]) != nil ? val : @"Help";
    livechat.chatView.maxInputLines = (val = [options objectForKey:@"maxlines"]) != nil ? val : 4;
    livechat.chatView.placeholder = (val = [options objectForKey:@"placeholder"]) != nil ? val : @"How can we help?";
    livechat.chatView.placeholderColor = (val = [options objectForKey:@"placeholdercolor"]) != nil ? colorFromHexString(val) : [UIColor grayColor];
    livechat.shouldUseSystemBrowser = (val = [options objectForKey:@"usesystembrowser"]) != nil ? (BOOL)val : FALSE;
    
    // email/name/context/customdata/pushtoken
    val = [options objectForKey:@"email"];
    if(val) livechat.chatView.email = val;
    val = [options objectForKey:@"name"];
    if(val) livechat.chatView.name = val;
    val = [options objectForKey:@"context"];
    if(val) livechat.chatView.context = val;
    val = [options objectForKey:@"customdata"];
    if(val) livechat.chatView.customdata = val;
    val = [options objectForKey:@"pushtoken"];
    if(val) [livechat.chatView setPushToken:val];
    
    // customize the status bar style
    livechat.overridePreferredStatusBarStyle = UIStatusBarStyleDefault;
    
    [self.viewController presentModalViewController:livechat animated:YES];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"OK"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)openHelpdeskSearch:(CDVInvokedUrlCommand*)command
{
    NSString * appid = (NSString *)[command.arguments objectAtIndex:0];
    NSDictionary * options = (NSDictionary *)[command.arguments objectAtIndex:1];
    NSString * userid = [options objectForKey:@"user"];
    HMHelpDeskSearchViewController * helpdesk = [[HMHelpDeskSearchViewController alloc] initWithAppID:appid andUser:userid andInfo:nil];
    
    // title bar color
    NSString * val = [options objectForKey:@"titlebarcolor"];
    if(val){
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f){
            if([helpdesk.navigationBar respondsToSelector:@selector(setBarTintColor:)]){
                helpdesk.navigationBar.barTintColor = colorFromHexString(val);
                helpdesk.navigationBar.translucent = FALSE;
            }else{
                helpdesk.navigationBar.tintColor = colorFromHexString(val);
            }
        }
    }
    
    //       [self setCustomTitleBar:helpdesk.body andTitle:@"Search Help"];
    val = [options objectForKey:@"defaultquery"];
    if(val) helpdesk.searchView.defaultQuery = val;
    helpdesk.shouldUseSystemBrowser = (val = [options objectForKey:@"usesystembrowser"]) != nil ? (BOOL)val : FALSE;
    
    // title
    helpdesk.body.title = (val = [options objectForKey:@"title"]) != nil ? val : @"Help";
    helpdesk.body.chatenabled = HMHelpDeskSearchChatEnabledAlways;
    val = [options objectForKey:@"chatenabled"];
    if(val){
        if([@"no" isEqualToString:val]){
            helpdesk.body.chatenabled = HMHelpDeskSearchChatEnabledNever;
        }else if([@"ifavailable" isEqualToString:val]){
            helpdesk.body.chatenabled = HMHelpDeskSearchChatEnabledIfOperatorAvailable;
        }
    }
    
    [self.viewController presentModalViewController:helpdesk animated:YES];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"OK"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)openHelpdeskArticle:(CDVInvokedUrlCommand*)command
{
    NSString * appid = (NSString *)[command.arguments objectAtIndex:0];
    NSString * articleurl = (NSString *)[command.arguments objectAtIndex:1];
    NSDictionary * options = (NSDictionary *)[command.arguments objectAtIndex:2];
    NSString * userid = [options objectForKey:@"user"];
    HMHelpDeskArticleViewController * helppage = [[HMHelpDeskArticleViewController alloc] initWithAppID:appid andArticleURL:articleurl andUser:userid andInfo:nil];
    
    // title bar color
    NSString * val = [options objectForKey:@"titlebarcolor"];
    if(val){
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f){
            if([helppage.navigationBar respondsToSelector:@selector(setBarTintColor:)]){
                helppage.navigationBar.barTintColor = colorFromHexString(val);
                helppage.navigationBar.translucent = FALSE;
            }else{
                helppage.navigationBar.tintColor = colorFromHexString(val);
            }
        }
    }
    
    // title
    helpdesk.body.title = (val = [options objectForKey:@"title"]) != nil ? val : @"Help";
    helpdesk.body.chatenabled = HMHelpDeskArticleChatEnabledAlways;
    val = [options objectForKey:@"chatenabled"];
    if(val){
        if([@"no" isEqualToString:val]){
            helppage.body.chatenabled = HMHelpDeskArticleChatEnabledNever;
        }else if([@"ifavailable" isEqualToString:val]){
            helppage.body.chatenabled = HMHelpDeskArticleChatEnabledIfOperatorAvailable;
        }
    }


    [self.viewController presentModalViewController:helppage animated:YES];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"OK"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
@end
