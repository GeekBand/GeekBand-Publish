//
//  JDAppDelegate.m
//  JDAPNS
//
//  Created by 段 松 on 13-6-4.
//  Copyright (c) 2013年 duansong. All rights reserved.
//

#import "JDAppDelegate.h"

@implementation JDAppDelegate

#pragma mark - Memory management methods

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

#pragma mark - Application lifecycle methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (launchOptions) {
        
    }
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge
                                                                           |UIRemoteNotificationTypeSound
                                                                           |UIRemoteNotificationTypeAlert)];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"%@", error.description);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *deviceTokenString = [deviceToken description];
    NSLog(@"deviceToken = %@", deviceTokenString);
    NSString *tokenValue = deviceTokenString;
    // delete flag '<' and '>' <fjlskdajflksadjflk234567>
    if ([deviceTokenString characterAtIndex:0] == '<') {
        NSRange range = {1, [deviceTokenString length] - 2};
        tokenValue = [deviceTokenString substringWithRange:range];
        NSLog(@"token value = %@", tokenValue);
    }
    // 最后拿到的tokenValue应该上传给服务器。
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:userInfo.description
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
