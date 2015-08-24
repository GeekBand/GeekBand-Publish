//
//  BLLoginViewController.m
//  BLDemo05
//
//  Created by derek on 7/10/15.
//  Copyright (c) 2015 derek. All rights reserved.
//

#import "BLLoginViewController.h"
#import "AppDelegate.h"
#import "BLGlobal.h"

@interface BLLoginViewController ()<BLLoginRequestDelegate>

@property(nonatomic, strong)BLLoginRequest *loginRequest;

@end

@implementation BLLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor cyanColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)loginButtonClicked:(id)sender {
    self.loginRequest = [[BLLoginRequest alloc] init];
    [self.loginRequest sendLoginRequestWithUserName:_userNameTextField.text
                                           password:_passwordTextField.text
                                           delegate:self];
    
}

#pragma mark - BLLoginRequestDelegate methods

- (void)requestFailed:(BLLoginRequest *)request error:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)requestSuccess:(BLLoginRequest *)request user:(BLUser *)user
{
    [BLGlobal shareGloabl].user = user;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate loadMainView];
}

@end
