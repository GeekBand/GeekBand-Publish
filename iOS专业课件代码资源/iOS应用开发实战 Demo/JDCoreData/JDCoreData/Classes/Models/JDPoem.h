//
//  JDPoem.h
//  JDCoreData
//
//  Created by 段 松 on 13-6-6.
//  Copyright (c) 2013年 duansong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class JDPoet;

@interface JDPoem : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * favorite;
@property (nonatomic, retain) JDPoet *poet;

@end
