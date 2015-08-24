//
//  BLLoginViewController.h
//  BLDemo05
//
//  Created by derek on 7/10/15.
//  Copyright (c) 2015 derek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLLoginRequest.h"

@interface BLLoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)loginButtonClicked:(id)sender;

@end
