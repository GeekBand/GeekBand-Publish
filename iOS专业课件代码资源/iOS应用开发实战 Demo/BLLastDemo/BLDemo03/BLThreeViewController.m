//
//  BLThreeViewController.m
//  BLDemo03
//
//  Created by derek on 6/28/15.
//  Copyright (c) 2015 derek. All rights reserved.
//

#import "BLThreeViewController.h"

@interface BLThreeViewController ()

@end

@implementation BLThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Three";
    self.bgImageView.image = [UIImage imageNamed:@"bg3.png"];
}

#pragma mark - Memory management methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
