//
//  JDMainViewController.m
//  JDCoreData
//
//  Created by 段 松 on 13-6-6.
//  Copyright (c) 2013年 duansong. All rights reserved.
//

#import "JDMainViewController.h"
#import "JDAppDelegate.h"

@interface JDMainViewController ()

@end

@implementation JDMainViewController

#pragma mark - View lifecycle methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.motionManager = [[[CMMotionManager alloc] init] autorelease];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    bgImageView.image = [UIImage imageNamed:@"Default.png"];
    [self.view addSubview:bgImageView];
    [bgImageView release];
    
    UIButton *checkAccelerometerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    checkAccelerometerButton.frame = CGRectMake(10, 10, 300, 40);
    [checkAccelerometerButton setTitle:@"监测加速计" forState:UIControlStateNormal];
    [checkAccelerometerButton addTarget:self
                                 action:@selector(checkAccelerometerButtonClicked:)
                       forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:checkAccelerometerButton];
    
    UIButton *checkGyroButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    checkGyroButton.frame = CGRectMake(10, 60, 300, 40);
    [checkGyroButton setTitle:@"监测陀螺仪" forState:UIControlStateNormal];
    [checkGyroButton addTarget:self
                        action:@selector(checkGyroButtonClicked:)
              forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:checkGyroButton];
    
    UIButton *startAccelerometerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    startAccelerometerButton.frame = CGRectMake(10, 110, 145, 40);
    [startAccelerometerButton setTitle:@"开启加速计" forState:UIControlStateNormal];
    [startAccelerometerButton addTarget:self
                                 action:@selector(startAccelerometerButtonClicked:)
                       forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startAccelerometerButton];

    UIButton *stopAccelerometerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    stopAccelerometerButton.frame = CGRectMake(165, 110, 145, 40);
    [stopAccelerometerButton setTitle:@"停止加速计" forState:UIControlStateNormal];
    [stopAccelerometerButton addTarget:self
                                action:@selector(stopAccelerometerButtonClicked:)
                      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopAccelerometerButton];
    
    UIButton *startGyroButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    startGyroButton.frame = CGRectMake(10, 160, 145, 40);
    [startGyroButton setTitle:@"开启陀螺仪" forState:UIControlStateNormal];
    [startGyroButton addTarget:self
                                 action:@selector(startGyroButtonClicked:)
                       forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startGyroButton];
    
    UIButton *stopGyroButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    stopGyroButton.frame = CGRectMake(165, 160, 145, 40);
    [stopGyroButton setTitle:@"停止陀螺仪" forState:UIControlStateNormal];
    [stopGyroButton addTarget:self
                                action:@selector(stopGyroButtonClicked:)
                      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopGyroButton];
    
    _accelerometerInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 210, 300, 115)];
    _accelerometerInfoLabel.backgroundColor = [UIColor cyanColor];
    _accelerometerInfoLabel.numberOfLines = 0;
    _accelerometerInfoLabel.font = [UIFont systemFontOfSize:14.0];
    [self.view addSubview:_accelerometerInfoLabel];
    [_accelerometerInfoLabel release];
    
    _gyroInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 335, 300, 115)];
    _gyroInfoLabel.backgroundColor = [UIColor whiteColor];
    _gyroInfoLabel.numberOfLines = 0;
    _gyroInfoLabel.font = [UIFont systemFontOfSize:14.0];
    [self.view addSubview:_gyroInfoLabel];
    [_gyroInfoLabel release];
}

#pragma mark - Custom event methods

- (void)checkAccelerometerButtonClicked:(id)sender
{
    NSString *alertTitle = nil;
    NSString *alertMessage = nil;
    if ([self.motionManager isAccelerometerAvailable]) {
        alertTitle = @"加速计可用";
    }else {
        alertTitle = @"加速计不可用";
    }
    if ([self.motionManager isAccelerometerActive]) {
        alertMessage = @"加速计处于激活状态";
    }else {
        alertMessage = @"加速计没有激活";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertMessage
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

- (void)checkGyroButtonClicked:(id)sender
{
    NSString *alertTitle = nil;
    NSString *alertMessage = nil;
    if ([self.motionManager isGyroAvailable]) {
        alertTitle = @"陀螺仪可用";
    }else {
        alertTitle = @"陀螺仪不可用";
    }
    if ([self.motionManager isGyroActive]) {
        alertMessage = @"陀螺仪处于激活状态";
    }else {
        alertMessage = @"陀螺仪没有激活";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertMessage
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

- (void)updateAccelerometerInfoLabel:(NSString *)message
{
    _accelerometerInfoLabel.text = message;
}

- (void)startAccelerometerButtonClicked:(id)sender
{
    if ([self.motionManager isAccelerometerAvailable] && ![self.motionManager isAccelerometerActive]) {
        _accelerometerQueue = [[NSOperationQueue alloc] init];
        [self.motionManager startAccelerometerUpdatesToQueue:_accelerometerQueue
                                                 withHandler:^(CMAccelerometerData *accelerometerData, NSError *error)
         {
             // 取值范围 －1～＋1
             NSString *message = [NSString stringWithFormat:@"加速计: \nx: %f\ny: %f\nz: %f",
                                 accelerometerData.acceleration.x,
                                 accelerometerData.acceleration.y,
                                 accelerometerData.acceleration.z];
             [self performSelectorOnMainThread:@selector(updateAccelerometerInfoLabel:)
                                    withObject:message
                                 waitUntilDone:YES];
        }];
    }else {
        
    }
}

- (void)stopAccelerometerButtonClicked:(id)sender
{
    [self.motionManager stopAccelerometerUpdates];
    [_accelerometerQueue release];
    _accelerometerQueue = nil;
}

- (void)updateGyroInfoLabel:(NSString *)message
{
    _gyroInfoLabel.text = message;
}

- (void)startGyroButtonClicked:(id)sender
{
    if ([self.motionManager isGyroAvailable] && ![self.motionManager isGyroActive]) {
        _gyroQueue = [[NSOperationQueue alloc] init];
        [self.motionManager setGyroUpdateInterval:1.0 / 10.0];
        [self.motionManager startGyroUpdatesToQueue:_gyroQueue withHandler:^(CMGyroData *gyroData, NSError *error)
         {
             NSString *message = [NSString stringWithFormat:@"陀螺仪: \nx: %f\ny: %f\nx: %f",
                                  gyroData.rotationRate.x,
                                  gyroData.rotationRate.y,
                                  gyroData.rotationRate.z];
             [self performSelectorOnMainThread:@selector(updateGyroInfoLabel:)
                                    withObject:message
                                 waitUntilDone:YES];
         }];
    }else {
        
    }
}

- (void)stopGyroButtonClicked:(id)sender
{
    [self.motionManager stopGyroUpdates];
    [_gyroQueue release];
    _gyroQueue = nil;
}


#pragma mark - Memroy management methods

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.motionManager = nil;
    [_accelerometerQueue release];
    _accelerometerQueue = nil;
    [_gyroQueue release];
    _gyroQueue = nil;
    [super dealloc];
}

@end
