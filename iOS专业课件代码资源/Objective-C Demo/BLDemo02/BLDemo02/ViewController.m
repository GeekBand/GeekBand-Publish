//
//  ViewController.m
//  BLDemo02
//
//  Created by derek on 6/9/15.
//  Copyright (c) 2015 derek. All rights reserved.
//

#import "ViewController.h"
#import "BLDragonView.h"
#import "NSString+URL.h"
#import "BLDragonView+Hide.h"

@interface ViewController ()
{
    BLDragonView *_dragonView1;
}

@property(nonatomic, retain)BLDragonView *dragonView;

@end

@implementation ViewController


- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:<#(NSString *)#> object:<#(id)#>];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)receiveDragonViewNotification:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSLog(@"time is %@", [userInfo valueForKey:@"time"]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveDragonViewNotification:) name:@"BLDragonViewNotification"
                                               object:nil];
    
    NSString *url = @"baidu.com";
    if ([url isURL]) {
        NSLog(@"是一个网址");
    }else {
        NSLog(@"不是一个网址");
    }
    
    CGFloat width = self.view.frame.size.width;
    _dragonView = [[BLDragonView alloc] initWithFrame:CGRectMake(0, 0, width, 180)];
    _dragonView.delegate = self;
    [self.view addSubview:_dragonView];
    
    _dragonView1
    = [[BLDragonView alloc] initWithFrame:CGRectMake(0, 350, width, 180)];
    _dragonView1.delegate = self;
    _dragonView1.tag = 100;
    _dragonView1.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_dragonView1];

    
    UIButton *hideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    hideButton.frame = CGRectMake((self.view.frame.size.width - 50) / 2, _dragonView.frame.origin.y + 180 + 100, 50, 50);
    [hideButton setImage:[UIImage imageNamed:@"hide.png"] forState:UIControlStateNormal];
    [self.view addSubview:hideButton];
    [hideButton addTarget:self
                   action:@selector(hideButtonClicked:)
         forControlEvents:UIControlEventTouchUpInside];
    
    _dragonStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 60, self.view.frame.size.width, 60)];
    _dragonStatusLabel.backgroundColor = [UIColor purpleColor];
    _dragonStatusLabel.numberOfLines = 0;
    _dragonStatusLabel.font = [UIFont systemFontOfSize:15];
    _dragonStatusLabel.textAlignment = NSTextAlignmentCenter;
    _dragonStatusLabel.text = @"dragon's status";
    _dragonStatusLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_dragonStatusLabel];
}

//- (void)backButtonClicked:(BLDragonView *)dragonView
//{
//    CGFloat X = dragonView.dragonImageView.frame.origin.x;
//    CGFloat Y = dragonView.dragonImageView.frame.origin.y;
//    _dragonStatusLabel.text
//    = [NSString stringWithFormat:@"后退，（x,y）=（%f, %f）", X, Y];
//}
//
- (void)forwardButtonClicked:(BLDragonView *)dragonView
{
    if (dragonView.tag == 100) {
        _dragonStatusLabel.text
        = [NSString stringWithFormat:@"前进"];
    }else {
        CGFloat X = dragonView.dragonImageView.frame.origin.x;
        CGFloat Y = dragonView.dragonImageView.frame.origin.y;
        _dragonStatusLabel.text
        = [NSString stringWithFormat:@"前进，（x,y）=（%f, %f）", X, Y];
    }
}

- (void)hideButtonClicked:(id)sender
{
    [_dragonView hideOrShow];
//    _dragonView.dragonImageView.hidden
//    = !_dragonView.dragonImageView.hidden;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

