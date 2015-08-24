//
//  NSString+URL.m
//  BLDemo02
//
//  Created by derek on 6/26/15.
//  Copyright (c) 2015 derek. All rights reserved.
//

#import "NSString+URL.h"

@implementation NSString (URL)

- (BOOL)isURL
{
    if ([self hasPrefix:@"http://"]) {
        return YES;
    }
    return NO;
}

@end
