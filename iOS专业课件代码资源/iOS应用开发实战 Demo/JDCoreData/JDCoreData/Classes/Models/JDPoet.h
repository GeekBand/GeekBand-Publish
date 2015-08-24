//
//  JDPoet.h
//  JDCoreData
//
//  Created by 段 松 on 13-6-6.
//  Copyright (c) 2013年 duansong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class JDPoem;

@interface JDPoet : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSSet *poems;
@end

@interface JDPoet (CoreDataGeneratedAccessors)

- (void)addPoemsObject:(JDPoem *)value;
- (void)removePoemsObject:(JDPoem *)value;
- (void)addPoems:(NSSet *)values;
- (void)removePoems:(NSSet *)values;
@end
