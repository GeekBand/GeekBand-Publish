//
//  BLFiveViewController.m
//  BLDemo03
//
//  Created by derek on 6/28/15.
//  Copyright (c) 2015 derek. All rights reserved.
//

#import "BLFiveViewController.h"

@interface BLFiveViewController ()

@end

@implementation BLFiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Five";
    self.bgImageView.image = [UIImage imageNamed:@"bg5.png"];
}

#pragma mark - Memory management methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
