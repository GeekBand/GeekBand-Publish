//
//  JDMainViewController.h
//  JDCoreData
//
//  Created by 段 松 on 13-6-6.
//  Copyright (c) 2013年 duansong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface JDMainViewController : UIViewController
{
    UILabel             *_accelerometerInfoLabel;
    UILabel             *_gyroInfoLabel;
    NSOperationQueue    *_accelerometerQueue;
    NSOperationQueue    *_gyroQueue;
}

@property (nonatomic, retain)CMMotionManager *motionManager;

@end
