//
//  BLArchiveViewController.h
//  BLDataSaveDemo
//
//  Created by duansong on 15-7-14.
//  Copyright 2015 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BLArchiveViewController : UIViewController < UITextFieldDelegate > {
	UITextField			*_userNameTextField;
	UITextField			*_emailTextField;
	UITextField			*_passwordTextField;
	UITextField			*_ageTextField;
}

- (void) initVariables;
- (void) initComponents;

@end
