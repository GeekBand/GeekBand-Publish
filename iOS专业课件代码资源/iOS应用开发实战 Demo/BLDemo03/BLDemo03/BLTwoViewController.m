//
//  BLTwoViewController.m
//  BLDemo03
//
//  Created by derek on 6/28/15.
//  Copyright (c) 2015 derek. All rights reserved.
//

#import "BLTwoViewController.h"

@interface BLTwoViewController ()

@end

@implementation BLTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Two";
    self.bgImageView.image = [UIImage imageNamed:@"bg2"];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 74, self.view.frame.size.width - 20, 31)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = @"please input password";
//    textField.secureTextEntry = YES;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    textField.keyboardType = UIKeyboardTypeEmailAddress;
    textField.returnKeyType = UIReturnKeyDone;
    textField.font = [UIFont systemFontOfSize:14.0f];
    textField.textColor = [UIColor cyanColor];
    textField.delegate = self;
    textField.contentVerticalAlignment = UIViewContentModeCenter;
    [self.view addSubview:textField];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, textField.frame.origin.y + 31 + 10, self.view.frame.size.width - 20, 80)];
    textView.backgroundColor = [UIColor redColor];
    textView.textColor = [UIColor blackColor];
    textView.delegate = self;
    textView.keyboardType = UIKeyboardTypeEmailAddress;
    textView.returnKeyType = UIReturnKeyGo;
    [self.view addSubview:textView];
}

#pragma mark - UITextFieldDelegate methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"%@", textField.text);
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSLog(@"%@", textField.text);
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"%@", textField.text);
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"%@", textView);
}

- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
