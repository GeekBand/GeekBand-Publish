//
//  BLUser.m
//  BLTableViewDemo
//
//  Created by 松 段 on 11-11-10.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "BLUser.h"

@implementation BLUser

@synthesize name            = _name;
@synthesize headImagePath   = _headImagePath;
@synthesize lifePhotoPath   = _lifePhotoPath;

+ (BLUser *)userWithName:(NSString *)aName 
       headImagePath:(NSString *)aHeadImagePath 
       lifePhotoPath:(NSString *)aLifePhotoPath {
    BLUser *user = [[BLUser alloc] init];
    user.name = aName;
    user.headImagePath = aHeadImagePath;
    user.lifePhotoPath = aLifePhotoPath;
    return user;
}

- (void)dealloc {    
    self.name           = nil;
    self.headImagePath  = nil;
    self.lifePhotoPath  = nil;
}

@end
