//
//  BLUserInfoViewController.m
//  BLDemo05
//
//  Created by derek on 7/10/15.
//  Copyright (c) 2015 derek. All rights reserved.
//

#import "BLUserInfoViewController.h"
#import "BLGlobal.h"
#import "BLImageDownloader.h"

@interface BLUserInfoViewController ()<BLImageDownloaderDelegate>
{
    BLImageDownloader       *_downloader;
    BOOL                    _isDownloading;
}

@end

@implementation BLUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"用户信息";
    
    self.constraint.constant = 44;
    
    self.userInfoLabel.text = [BLGlobal shareGloabl].user.userName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)downloadButtonClicked:(id)sender {
    if (_isDownloading) {
        return;
    }
    
    _isDownloading = YES;
    _progressView.progress = 0;
    _headImageView.image = nil;
    [_activityView startAnimating];
    
    if (_downloader == nil) {
        _downloader = [[BLImageDownloader alloc] init];
        _downloader.delegate = self;
    }
    [_downloader download:[BLGlobal shareGloabl].user.headImageUrl delegate:self];
}

- (void)downloadReceivedData:(BLImageDownloader *)downloader
{
    _progressView.progress
    = [downloader.receivedData length] / (double)downloader.totalLength;
}

- (void)downloadSuccess:(BLImageDownloader *)downloader data:(NSData *)data
{
    [_activityView stopAnimating];
    _isDownloading = NO;
    _headImageView.image = [[UIImage alloc] initWithData:data];
}

- (void)downloadFailed:(BLImageDownloader *)downloader error:(NSError *)error
{
    [_activityView stopAnimating];
    _isDownloading = NO;
}

@end
