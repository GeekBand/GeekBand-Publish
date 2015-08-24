//
//  BLFourViewController.m
//  BLDemo03
//
//  Created by derek on 6/28/15.
//  Copyright (c) 2015 derek. All rights reserved.
//

#import "BLFourViewController.h"

@interface BLFourViewController ()

@end

@implementation BLFourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Four";
    self.bgImageView.image = [UIImage imageNamed:@"bg4.png"];
}

#pragma mark - Memory management methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
