//
//  JDAppDelegate.m
//  JDBlockAndGCD
//
//  Created by 段 松 on 13-6-7.
//  Copyright (c) 2013年 duansong. All rights reserved.
//

#import "JDAppDelegate.h"
#import "JDMainViewController.h"

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
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    
    JDMainViewController *mainViewController = [[JDMainViewController alloc] init];
    self.window.rootViewController = mainViewController;
    [mainViewController release];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
