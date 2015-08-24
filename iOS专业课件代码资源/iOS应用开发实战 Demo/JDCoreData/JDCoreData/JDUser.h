//
//  JDUser.h
//  JDCoreData
//
//  Created by 段 松 on 13-6-15.
//  Copyright (c) 2013年 duansong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface JDUser : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSString * address;

@end
