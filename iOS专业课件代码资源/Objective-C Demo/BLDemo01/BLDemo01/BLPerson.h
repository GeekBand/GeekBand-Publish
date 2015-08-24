//
//  BLPerson.h
//  BLDemo01
//
//  Created by derek on 6/9/15.
//  Copyright (c) 2015 derek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLPerson : NSObject
{
//    NSString    *_name;
//    NSInteger   _age;
}

//nonatomic, atomic,
//copy, retain, strong, weak, assign,
//readonly
@property(nonatomic, copy)NSString *name;
@property(nonatomic, assign)NSInteger age;

+ (BLPerson *)createPerson;

- (instancetype)initWithName:(NSString *)name age:(NSInteger)age; // -initWithName:age: id
- (void)sayMyInfo; // 减号成员方法.

//- (void)say;

+ (void)printMessage:(NSString *)message; // 加号类方法. +printMessage:

//- (void)setName:(NSString *)aName;
//- (void)setAge:(NSInteger)age;
//
//- (NSString *)name;
//- (NSInteger)age;

@end
