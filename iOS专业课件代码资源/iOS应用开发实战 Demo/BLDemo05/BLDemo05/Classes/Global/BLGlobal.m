//
//  BLGlobal.m
//  BLDemo05
//
//  Created by derek on 15/7/25.
//  Copyright (c) 2015年 derek. All rights reserved.
//

#import "BLGlobal.h"

static BLGlobal *global = nil;

@implementation BLGlobal

+ (BLGlobal *)shareGloabl
{
    if (global == nil) {
        global = [[BLGlobal alloc] init];
    }
    return global;
}

@end
