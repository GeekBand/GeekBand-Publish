//
//  BLBaseViewController.m
//  BLDemo03
//
//  Created by derek on 6/28/15.
//  Copyright (c) 2015 derek. All rights reserved.
//

#import "BLBaseViewController.h"

@interface BLBaseViewController ()

@end

@implementation BLBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.bgImageView.backgroundColor = [UIColor clearColor];
    self.bgImageView.image = [UIImage imageNamed:@"bg1"];
    [self.view addSubview:self.bgImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
