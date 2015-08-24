//
//  BLCustomView.m
//  BLUIFrame
//
//  Created by derek on 15/8/19.
//  Copyright (c) 2015年 derek. All rights reserved.
//

#import "BLCustomView.h"

@implementation BLCustomView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, 0, 0);
    CGContextAddLineToPoint(ctx, 0, 100);
    CGContextAddLineToPoint(ctx, 100, 100);
    CGContextClosePath(ctx);
    CGContextSetFillColorWithColor(ctx, [UIColor yellowColor].CGColor);
    CGContextFillPath(ctx);
//    CGContextSetLineWidth(ctx, 5);
//    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
//    CGContextStrokePath(ctx);

    CGRect rectangle = CGRectMake(10, 120, 50, 50);
    CGContextAddEllipseInRect(ctx, rectangle);
    CGContextSetFillColorWithColor(ctx, [UIColor purpleColor].CGColor);
    CGContextFillPath(ctx);
}


@end
