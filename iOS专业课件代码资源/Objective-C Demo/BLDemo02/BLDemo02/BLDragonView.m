//
//  BLDragonView.m
//  BLDemo02
//
//  Created by derek on 6/9/15.
//  Copyright (c) 2015 derek. All rights reserved.
//

#import "BLDragonView.h"

@interface BLDragonView()

@property(nonatomic, copy, readwrite)NSString *name;

@end

@implementation BLDragonView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.name = @"dragon view";
        
        self.backgroundColor = [UIColor cyanColor];
        
        self.dragonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
        self.dragonImageView.image = [UIImage imageNamed:@"dragon.png"];
        self.dragonImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.dragonImageView];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(10, 120, 50, 50);
        [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [backButton addTarget:self
                       action:@selector(backButtonClicked:)
             forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backButton];
        
        UIButton *forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        forwardButton.frame = CGRectMake(frame.size.width - 60, 120, 50, 50);
        [forwardButton setImage:[UIImage imageNamed:@"forward.png"] forState:UIControlStateNormal];
        [forwardButton addTarget:self
                       action:@selector(forwardButtonClicked:)
             forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:forwardButton];
    }
    return self;
}

- (void)backButtonClicked:(id)sender
{
    CGFloat x = _dragonImageView.frame.origin.x - 10;
    if (x > 0) {
        _dragonImageView.frame = CGRectMake(x, _dragonImageView.frame.origin.y, 100, 100);
    }
    
    if ([_delegate respondsToSelector:@selector(backButtonClicked:)]) {
        [_delegate backButtonClicked:self];
    }
}

- (void)forwardButtonClicked:(id)sender
{
    CGFloat x = _dragonImageView.frame.origin.x + 10;
    if (x < self.frame.size.width - 100) {
        _dragonImageView.frame = CGRectMake(x, _dragonImageView.frame.origin.y, 100, 100);
    }
    if ([_delegate respondsToSelector:@selector(forwardButtonClicked:)]) {
        [_delegate forwardButtonClicked:self];
    }
    
    NSDictionary *dic = @{@"name":@"123456789", @"time": @"05:58"};
    NSNotification *notification
    = [[NSNotification alloc] initWithName:@"BLDragonViewNotification"
                                    object:nil
                                  userInfo:dic];
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                               postingStyle:NSPostNow
                                               coalesceMask:NSNotificationNoCoalescing
                                                   forModes:nil];
}

@end
