//
//  BLTwoViewController.m
//  BLDemo03
//
//  Created by derek on 6/28/15.
//  Copyright (c) 2015 derek. All rights reserved.
//

#import "BLTwoViewController.h"
#import "BLCustomView.h"

@interface BLTwoViewController ()

@end

@implementation BLTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Two";
    self.bgImageView.image = [UIImage imageNamed:@"bg2.png"];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 50)];
    bgView.backgroundColor = [UIColor redColor];
    [self.view addSubview:bgView];
    
    bgView.layer.backgroundColor = [UIColor cyanColor].CGColor;
    bgView.layer.cornerRadius = 50;
    bgView.layer.shadowOffset = CGSizeMake(5, 0);
    bgView.layer.shadowColor = [UIColor blackColor].CGColor;

    CALayer *layer = [[CALayer alloc] init];
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    layer.cornerRadius = 20;
    layer.shadowRadius = 20;
    layer.shadowOffset = CGSizeMake(5, 5);
    layer.shadowOpacity = 0.8;
    layer.borderColor = [UIColor redColor].CGColor;
    layer.borderWidth = 5;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.frame = CGRectMake(50, 70, 100, 100);
    [bgView.layer addSublayer:layer];

    CALayer *imageLayer = [CALayer layer];
    imageLayer.backgroundColor = [UIColor blueColor].CGColor;
    imageLayer.cornerRadius = 20;
    imageLayer.shadowRadius = 20;
    imageLayer.shadowOffset = CGSizeMake(5, 5);
    imageLayer.shadowOpacity = 1;
    imageLayer.shadowColor = [UIColor blackColor].CGColor;
    imageLayer.borderColor = [UIColor greenColor].CGColor;
    imageLayer.borderWidth = 5;
    imageLayer.frame = CGRectMake(160, 70, 100, 100);
    imageLayer.masksToBounds = YES;
    
    CGImageRef imageRef =  [UIImage imageNamed:@"bg1.png"].CGImage;
    
    imageLayer.contents = (__bridge id)imageRef;
    [bgView.layer addSublayer:imageLayer];

    
    BLCustomView *customView = [[BLCustomView alloc] initWithFrame:CGRectMake(10, 200, self.view.bounds.size.width - 20, 200)];
    customView.backgroundColor = [UIColor blackColor];
    [bgView addSubview:customView];

}

#pragma mark - Memory management methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
