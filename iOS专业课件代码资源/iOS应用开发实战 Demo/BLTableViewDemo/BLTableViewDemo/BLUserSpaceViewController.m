//
//  BLUserSpaceViewController.m
//  BLTableViewDemo
//
//  Created by 松 段 on 11-11-10.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "BLUserSpaceViewController.h"
#import "BLMessage.h"

@implementation BLUserSpaceViewController

@synthesize message = _message;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = self.message.sender.name;
    
    UIImage *image = [UIImage imageWithContentsOfFile:self.message.sender.lifePhotoPath];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.image = image;
    [self.view addSubview:imageView];
}


#pragma mark - Memory management methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    self.message = nil;
}


@end
