//
//  BLUser.h
//  BLDemo05
//
//  Created by derek on 15/7/25.
//  Copyright (c) 2015年 derek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLAddress.h"

@interface BLUser : NSObject

@property(nonatomic, copy)NSString *userId;
@property(nonatomic, copy)NSString *userName;
@property(nonatomic, assign)NSInteger age;
@property(nonatomic, copy)NSString *headImageUrl;
@property(nonatomic, strong)BLAddress *address;

@end
