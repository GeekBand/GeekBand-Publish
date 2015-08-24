//
//  BLOneViewController.m
//  BLDemo03
//
//  Created by derek on 6/28/15.
//  Copyright (c) 2015 derek. All rights reserved.
//

#import "BLOneViewController.h"
#import "BLSubViewController.h"

#define kOneAlertViewTag        100
#define kPushButtonTag          101
#define kPresentButtonTag       102

@interface BLOneViewController ()<UIAlertViewDelegate, UIActionSheetDelegate>

@end

@implementation BLOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"One";
    
//    CGPoint point = CGPointMake(10, 10);
//    CGRect rect = CGRectMake(10, 10, 100, 200);
//    UIColor *color
//    = [UIColor colorWithRed:53 / 255.0  green:93 / 255.0 blue:249 / 255.0 alpha:0.3];
    
    UIButton *pushButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pushButton.tag = kPushButtonTag;
    pushButton.frame = CGRectMake(10, 74, self.view.bounds.size.width - 20, 44);
    [pushButton setBackgroundColor:[UIColor clearColor]];
    UIImage *blueBGImage = [UIImage imageNamed:@"blueButton.png"];
    UIImage *stretchableBlueBGImage = [blueBGImage stretchableImageWithLeftCapWidth:10 topCapHeight:20];
    [pushButton setBackgroundImage:stretchableBlueBGImage
                          forState:UIControlStateNormal];
    [pushButton setTitle:@"push a view" forState:UIControlStateNormal];
    [pushButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [pushButton addTarget:self
//                   action:@selector(pushButtonClicked:)
//         forControlEvents:UIControlEventTouchUpInside];
    [pushButton addTarget:self
                   action:@selector(buttonClicked:)
         forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:pushButton];
    
    UIButton *presentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    presentButton.tag = kPresentButtonTag;
//    presentButton.hidden = NO;
    presentButton.frame = CGRectMake(10, 128, self.view.bounds.size.width - 20, 44);
    [presentButton setBackgroundColor:[UIColor clearColor]];
    [presentButton setTitleColor:[UIColor colorWithRed:30 / 255.0f green:90 / 255.0f blue:19 / 255.0f alpha:1] forState:UIControlStateNormal];
    UIImage *whiteBGImage = [UIImage imageNamed:@"whiteButton.png"];
    UIImage *stretchableWhiteBGImage = [whiteBGImage stretchableImageWithLeftCapWidth:10 topCapHeight:20];
    [presentButton setBackgroundImage:stretchableWhiteBGImage
                             forState:UIControlStateNormal];
    [presentButton setTitle:@"present modal view" forState:UIControlStateNormal];
    [presentButton setTitle:@"clicked!!!" forState:UIControlStateHighlighted];

    [presentButton addTarget:self
                   action:@selector(buttonClicked:)
         forControlEvents:UIControlEventTouchUpInside];

//    [presentButton addTarget:self
//                   action:@selector(presentButtonClicked:)
//         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:presentButton];
    
    UIBarButtonItem *alertButton
    = [[UIBarButtonItem alloc] initWithTitle:@"alert"
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(alertButtonClicked:)];
    self.navigationItem.rightBarButtonItem = alertButton;
    
    UIImageView *imageView
    = [[UIImageView alloc] initWithFrame:CGRectMake(10, presentButton.frame.origin.y + presentButton.frame.size.height + 10,self.view.frame.size.width - 20, 100)];
    imageView.image = [UIImage imageNamed:@"bg5.png"];
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, imageView.frame.origin.y + imageView.frame.size.height + 10,self.view.frame.size.width - 20, 20)];
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = [UIColor blueColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16.0f];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:label];
    
    label.text = @"this is a label!this is a label!this this this is a label!this is a label!this is a label!this is a label!this this this is a label!this is a label!!this this this is a label!this is a label!this is a label!this is a label!this this this is a label!this is a label!";
    
    CGSize textSize = [label.text boundingRectWithSize:CGSizeMake(label.frame.size.width - 25, CGFLOAT_MAX)
                                              options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16], }
                                              context:nil].size;
    
    label.frame = CGRectMake(10, label.frame.origin.y, textSize.width, textSize.height);
}

#pragma mark - Custom event methods

- (void)alertButtonClicked:(UIBarButtonItem *)button
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"title"
                                                    message:@"alert message. fasjklfjslakdjflksdaj"
                                                   delegate:self
                                          cancelButtonTitle:@"ok"
                                          otherButtonTitles:@"one", @"two", nil];
    alert.tag = kOneAlertViewTag;
    [alert show];
//    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)buttonClicked:(UIButton *)sender
{
    if (sender.tag == kPresentButtonTag) {
        BLSubViewController *subViewController = [[BLSubViewController alloc] init];
        [self presentViewController:subViewController animated:YES completion:nil];

    }else if(sender.tag == kPushButtonTag) {
        BLSubViewController *subViewController = [[BLSubViewController alloc] init];
        [self.navigationController pushViewController:subViewController animated:YES];
    }
}

- (void)pushButtonClicked:(id)sender
{
    BLSubViewController *subViewController = [[BLSubViewController alloc] init];
    [self.navigationController pushViewController:subViewController animated:YES];
}

- (void)presentButtonClicked:(id)sender
{
    BLSubViewController *subViewController = [[BLSubViewController alloc] init];
    [self presentViewController:subViewController animated:YES completion:nil];
}

#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kOneAlertViewTag) {
        NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
        if ([buttonTitle isEqualToString:@"one"]) {
            UIActionSheet *actionSheet
            = [[UIActionSheet alloc] initWithTitle:@"title"
                                          delegate:self
                                 cancelButtonTitle:@"cancel"
                            destructiveButtonTitle:@"destructive"
                                 otherButtonTitles:@"one", @"two", nil];
//            [actionSheet showInView:self.view];
//            [actionSheet showFromTabBar:self.tabBarController.tabBar];
            [actionSheet showInView:self.view.window];
        }
    }
}

#pragma mark - Memory management methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
