//
//  AppDelegate.h
//  BLDemo05
//
//  Created by derek on 7/10/15.
//  Copyright (c) 2015 derek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *loginNavigationVC;

- (void)loadLoginView;
- (void)loadMainView;

@end

