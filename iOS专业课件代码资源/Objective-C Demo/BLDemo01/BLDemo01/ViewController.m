//
//  ViewController.m
//  BLDemo01
//
//  Created by derek on 6/9/15.
//  Copyright (c) 2015 derek. All rights reserved.
//

#import "ViewController.h"
#import "BLPerson.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)dealloc
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    BLPerson *tempPerson = [BLPerson createPerson];
    [tempPerson sayMyInfo];

    NSNumber *int1 = [NSNumber numberWithInt:1];
    
    NSArray *array = [[NSArray alloc] initWithObjects:tempPerson, int1, tempPerson, nil];
    
    NSLog(@"array count = %li", [array count]);
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    [mutableArray addObject:tempPerson];
    [mutableArray addObject:int1];
    [mutableArray removeObjectAtIndex:0];
    [mutableArray replaceObjectAtIndex:0 withObject:tempPerson];
    
    id object = [mutableArray objectAtIndex:0];
    if ([[object class] isSubclassOfClass:[NSNumber class]]) {
        NSInteger intValue = [(NSNumber *)object integerValue];
        NSLog(@"intValue = %li", intValue);
    }else if ([[object class] isSubclassOfClass:[BLPerson class]]) {
        [(BLPerson *)object sayMyInfo];
    }
    
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:tempPerson, @"person", int1, @"int", nil];
    NSArray *allKeys = [dictionary allKeys];
    for (int i = 0; i < [allKeys count]; i++) {
        NSString *key = allKeys[i];
        id object = [dictionary valueForKey:key];
        if ([[object class] isSubclassOfClass:[NSNumber class]]) {
            NSInteger intValue = [(NSNumber *)object integerValue];
            NSLog(@"intValue = %li", intValue);
        }else if ([[object class] isSubclassOfClass:[BLPerson class]]) {
            [(BLPerson *)object sayMyInfo];
        }
    }
    
    for (NSString *key in allKeys) {
        id object = [dictionary valueForKey:key];
        if ([[object class] isSubclassOfClass:[NSNumber class]]) {
            NSInteger intValue = [(NSNumber *)object integerValue];
            NSLog(@"intValue = %li", intValue);
        }else if ([[object class] isSubclassOfClass:[BLPerson class]]) {
            [(BLPerson *)object sayMyInfo];
        }
    }
    
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
    [mutableDic setValue:tempPerson forKey:@"person"];
    [mutableDic setValue:int1 forKey:@"int"];

    [mutableDic removeObjectForKey:@"person"];
    
    [mutableDic setValue:[NSNumber numberWithDouble:3.14] forKey:@"int"];
    
//    BLPerson *tempPerson = [BLPerson createPerson];
//    [tempPerson sayMyInfo];
    
    BLPerson * zhangsan = [[BLPerson alloc] init];  // ARC
    [zhangsan sayMyInfo];
    
    BLPerson *lisi = [[BLPerson alloc] initWithName:@"lisi" age:30];
    [lisi sayMyInfo];
    [lisi setName:@"李斯"];
    [lisi setAge:90];
    [lisi sayMyInfo];
    
    NSString *lisiName = [lisi name];
    NSInteger lisiAge = [lisi age];
    NSLog(@"lisiName = %@, lisiAge = %li", lisiName, lisiAge);
    
    
    BLPerson *wangwu;
    wangwu = [BLPerson alloc];
    wangwu = [wangwu initWithName:@"wangwu" age:80];
    [wangwu sayMyInfo];
    
    NSMutableString *personName = [NSMutableString stringWithString:@"王五"];
    [wangwu setName:personName];
    NSLog(@"personName = %@, wangwu's name = %@", personName, [wangwu name]);
    
    [personName appendString:@"123"];
    NSLog(@"personName = %@, wangwu's name = %@", personName, [wangwu name]);
    
    [wangwu sayMyInfo];
    
    wangwu.name = @"1234567890";  //[wangwu setName:@"1234567890"];
    wangwu.age = 10;               //[wangwu setAge:10];
    [wangwu sayMyInfo];
    
    NSLog(@"wangwu: name is %@, age is %li", wangwu.name, wangwu.age);
    NSLog(@"wangwu: name is %@, age is %li", [wangwu name], [wangwu age]);

    
    [BLPerson printMessage:@"hi, iOS!"];
    
    
    NSInteger age = 18;
    if (age >= 18) {
        NSLog(@"hi，您已经是一个成年人了！");
        //NSLog(@"hi，您已经是一个成年人了！");
        
        if (age >= 60) {
            NSLog(@"我现在已经太老了！");
        }
        
    }else {
        if (age < 3) {
            NSLog(@"我太小了");
        }
        NSLog(@"哈哈，你还是一个未成年！");
    }
    
    NSInteger test;
    test =  age >=18 ? 9 : 10;
    
    if (age >= 18) {
        test = 9;
    }else {
        test = 10;
    }
    
    NSInteger price = 4;
    switch (price) {
        case 4:
        {
            NSLog(@"4....");
            NSLog(@"4....");
            NSLog(@"4....");
        }
            
        case 3:
            NSLog(@"3....");
            
        case 2:
            NSLog(@"2....");
            break;
            
        default:
            NSLog(@"default....");
            break;
    }
    
    bool isFemale = false;
    BOOL isMale = YES;
    if (isMale) {
        
    }
    
    int sum = 0;  // sum = 1+2+3+.....+100
    for (int i = 1; i <= 100; ++i) {
        sum += i; // sum = sum + i;
    }
    NSLog(@"sum = %i", sum);
    
    sum = 0;
    int j = 1;
    for (;;) {
        sum += j;
        ++j;
        if (j > 100) {
            break;  // 跳出整个循环。
        }
    }
    NSLog(@"sum = %i", sum);
    
    sum = 0;
    j = 1;
    for (; j <= 100; ++j) {
        if (j % 2 == 0) {
            continue;  // 跳过当次循环，进入下一次循环。
        }
        sum += j;
    }
    NSLog(@"sum = %i", sum);
    
    sum = 0;
    j = 1;
    while (j <= 100) {
        sum += j;
        j++;
    }
    NSLog(@"sum = %i", sum);
    
    sum = 0;
    j = 1;
    do {
        sum += j;
        j++;
    } while (j <= 100);
    NSLog(@"---> sum = %i", sum);
    
    typedef NSInteger BLAge; // 类型新定义
    BLAge myAge = 10;  // NSInteger myAge = 10;
    
    // typedef long NSInteger;
    
    
    enum Person {GoodGirl, BadBoy, BadGirl, GoodBoy}; // 枚举分量都是整数
    enum Person myself;
    myself = GoodBoy;
    if (myself == GoodBoy) {
        
    }
    
    typedef enum {
        PersonTypeGoodGirl,
        PersonTypeGoodBoy
    } MyPersonType;
    
    MyPersonType aPerson = PersonTypeGoodBoy;
    
    struct MyPoint {CGFloat x; CGFloat y;};
    struct MyPoint myPoint = {6, 8};
    CGFloat result = myPoint.x + myPoint.y;
    NSLog(@"result = %f", result);
    
    typedef struct {CGFloat width; CGFloat height;} MySize;
    MySize size = {60, 90};
    size.width = 80;
    
#define PI 3.1415926
    
    CGFloat r = 5;
    CGFloat area = PI * r * r;
    
#define MYSUM(a,b) a*b
    sum = MYSUM(7, 8); // sum = 7 * 8
    NSLog(@"sum = %d", sum);
    
    
#ifdef NOPI
    NSLog(@"pi.....");
#else
    NSLog(@"no pi.....");
#endif
    
    
    /*
     char name[] = "Derek";
     printf(name);
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
