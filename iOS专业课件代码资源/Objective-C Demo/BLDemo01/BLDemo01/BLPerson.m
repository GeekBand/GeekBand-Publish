//
//  BLPerson.m
//  BLDemo01
//
//  Created by derek on 6/9/15.
//  Copyright (c) 2015 derek. All rights reserved.
//

#import "BLPerson.h"

@implementation BLPerson

//@synthesize name = _name;
//@synthesize age = _age;

- (void)dealloc
{
//    self.name = nil;
    
    [_name release];
    _name = nil;
    
    [super dealloc];
}

+ (BLPerson *)createPerson
{
    BLPerson *person = [[BLPerson alloc] initWithName:@"未设置" age:0];
    return [person autorelease];
}

- (instancetype)initWithName:(NSString *)name age:(NSInteger)age
{
    self = [super init]; // nil 0x0
    if (self) {
        self.name = name;
        self.age = age;
    }
    return self;
}

- (void)sayMyInfo
{
    NSLog(@"我叫 %@, 今年 %li 岁", _name, self.age);
}

//- (void)setName:(NSString *)aName
//{
//    if (_name) {
//        [_name release];
//    }
//    _name = [aName copy];
//}
//
//- (void)setAge:(NSInteger)age
//{
//    _age = age;
//}
//
//- (NSString *)name
//{
//    return _name;
//}
//
//- (NSInteger)age
//{
//    return _age;
//}

+ (void)printMessage:(NSString *)message
{
    NSLog(@"已经打印出：%@", message);
}

@end
