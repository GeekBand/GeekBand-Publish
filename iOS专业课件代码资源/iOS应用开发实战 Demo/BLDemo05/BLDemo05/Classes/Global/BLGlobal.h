//
//  BLGlobal.h
//  BLDemo05
//
//  Created by derek on 15/7/25.
//  Copyright (c) 2015年 derek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLUser.h"

@interface BLGlobal : NSObject

@property(nonatomic, strong)BLUser *user;

+ (BLGlobal *)shareGloabl;

@end
