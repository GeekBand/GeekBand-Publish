//
//  AppDelegate.m
//  BLDemo03
//
//  Created by derek on 6/28/15.
//  Copyright (c) 2015 derek. All rights reserved.
//

#import "AppDelegate.h"
#import "BLOneViewController.h"
#import "BLTwoViewController.h"
#import "BLThreeViewController.h"
#import "BLFourViewController.h"
#import "BLFiveViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - Cutom methods

- (void)loadMainFrame
{
    BLOneViewController *oneViewController = [[BLOneViewController alloc] init];
    UINavigationController *oneNavigationController
    = [[UINavigationController alloc] initWithRootViewController:oneViewController];
    oneNavigationController.tabBarItem.title = @"One";
    oneNavigationController.tabBarItem.image = [UIImage imageNamed:@"one.png"];
//    oneNavigationController.navigationBar.translucent = NO;
    
    BLTwoViewController *twoViewController = [[BLTwoViewController alloc] init];
    UINavigationController *twoNavigationController
    = [[UINavigationController alloc] initWithRootViewController:twoViewController];
    twoNavigationController.tabBarItem.title = @"Two";
    twoNavigationController.tabBarItem.image = [UIImage imageNamed:@"two.png"];

    BLThreeViewController *threeViewController = [[BLThreeViewController alloc] init];
    UINavigationController *threeNavigationController
    = [[UINavigationController alloc] initWithRootViewController:threeViewController];
    threeNavigationController.tabBarItem.title = @"Three";
    threeNavigationController.tabBarItem.image = [UIImage imageNamed:@"three.png"];

    BLFourViewController *fourViewController = [[BLFourViewController alloc] init];
    UINavigationController *fourNavigationController
    = [[UINavigationController alloc] initWithRootViewController:fourViewController];
    fourNavigationController.tabBarItem.title = @"Four";
    fourNavigationController.tabBarItem.image = [UIImage imageNamed:@"four.png"];

    BLFiveViewController *fiveViewController = [[BLFiveViewController alloc] init];
    UINavigationController *fiveNavigationController
    = [[UINavigationController alloc] initWithRootViewController:fiveViewController];
    fiveNavigationController.tabBarItem.title = @"Five";
    fiveNavigationController.tabBarItem.image = [UIImage imageNamed:@"five.png"];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
//    NSArray *viewControllers = [NSArray arrayWithObjects:oneNavigationController, nil];
//    NSDictionary *dic = @{@"name":@"zhangsan", @"age":@30};
    [tabBarController setViewControllers:@[oneNavigationController,
                                           twoNavigationController,
                                           threeNavigationController,
                                           fourNavigationController,
                                           fiveNavigationController]];
    
    self.window.rootViewController = tabBarController;
}

#pragma mark - Application lifecycle methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self loadMainFrame];
    [self.window makeKeyAndVisible];
    
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
