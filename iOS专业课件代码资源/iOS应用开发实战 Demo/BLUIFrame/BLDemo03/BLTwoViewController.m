//
//  BLTwoViewController.m
//  BLDemo03
//
//  Created by derek on 6/28/15.
//  Copyright (c) 2015 derek. All rights reserved.
//

#import "BLTwoViewController.h"

@interface BLTwoViewController ()

@end

@implementation BLTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Two";
    self.bgImageView.image = [UIImage imageNamed:@"bg2.png"];
}

#pragma mark - Memory management methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
