//
//  BLUser.h
//  BLTableViewDemo
//
//  Created by 松 段 on 11-11-10.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLUser : NSObject {
    NSString         *_name;
    NSString         *_headImagePath;
    NSString         *_lifePhotoPath;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *headImagePath;
@property (nonatomic, copy) NSString *lifePhotoPath;

+ (BLUser *)userWithName:(NSString *)aName 
       headImagePath:(NSString *)aHeadImagePath 
       lifePhotoPath:(NSString *)aLifePhotoPath;

@end
