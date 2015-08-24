//
//  BLOneViewController.m
//  BLDemo03
//
//  Created by derek on 6/28/15.
//  Copyright (c) 2015 derek. All rights reserved.
//

#import "BLOneViewController.h"

@interface BLOneViewController ()
{
    UIImageView *_imageView;
    UIActivityIndicatorView *_activityIndicatorView;
}

@end

@implementation BLOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"One";
    self.bgImageView.image = [UIImage imageNamed:@"bg1.png"];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 200)];
    _imageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_imageView];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.hidesWhenStopped = YES;
    _activityIndicatorView.frame = CGRectMake(self.view.bounds.size.width - 20 / 2, 200, 20, 20);
    [self.view addSubview:_activityIndicatorView];
    
    UIButton *downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    downloadButton.backgroundColor = [UIColor cyanColor];
    [downloadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    downloadButton.frame = CGRectMake(10, _imageView.bounds.size.height + 10, self.view.bounds.size.width - 20, 44);
    [downloadButton setTitle:@"下载图片" forState:UIControlStateNormal];
    [downloadButton addTarget:self action:@selector(downloadButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downloadButton];
}

// 同步下载
- (void)downloadBySync
{
    NSString *URLString = @"http://localhost/xampp/bl/images/jianmeile.PNG";
}

- (void)downloadButtonClicked:(id)sender
{
    
}

#pragma mark - Memory management methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
