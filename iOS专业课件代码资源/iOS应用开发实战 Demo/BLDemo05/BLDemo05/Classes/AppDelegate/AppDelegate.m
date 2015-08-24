//
//  AppDelegate.m
//  BLDemo05
//
//  Created by derek on 7/10/15.
//  Copyright (c) 2015 derek. All rights reserved.
//

#import "AppDelegate.h"
#import "BLUserInfoViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)loadLoginView
{
    UIStoryboard *storyboard
    = [UIStoryboard storyboardWithName:@"Login"
                                bundle:[NSBundle mainBundle]];
    self.loginNavigationVC = storyboard.instantiateInitialViewController;
    self.window.rootViewController = self.loginNavigationVC;
}


- (void)loadMainView
{
    UIStoryboard *storyboard
    = [UIStoryboard storyboardWithName:@"UserInfo" bundle:[NSBundle mainBundle]];
    BLUserInfoViewController *userInfoVC
    = [storyboard instantiateViewControllerWithIdentifier:@"BLUserInfoViewController"];
    UINavigationController *navc
    = [[UINavigationController alloc] initWithRootViewController:userInfoVC];
    navc.tabBarItem.title = @"userInfo";
    
    UITabBarController *tabBarC = [[UITabBarController alloc] init];
    tabBarC.viewControllers = @[navc];
    
    self.window.rootViewController = tabBarC;
    
    [self.window addSubview:self.loginNavigationVC.view];
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.loginNavigationVC.view.alpha = 0;
                         self.loginNavigationVC.view.frame = CGRectZero;
                         self.loginNavigationVC.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
                     } completion:^(BOOL finished) {
                         self.loginNavigationVC = nil;
                     }];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self loadLoginView];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
