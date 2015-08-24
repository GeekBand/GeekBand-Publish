//
//  JDMainViewController.m
//  JDCoreData
//
//  Created by 段 松 on 13-6-6.
//  Copyright (c) 2013年 duansong. All rights reserved.
//

#import "JDMainViewController.h"

// Grand Central Dispatch(GCD) 是一个与Block Object 产生工作的低级C API， GCD会将任务分配到多个核心，程序员不用关心任务到底在哪个内核执行。

@interface JDMainViewController ()

@end

@implementation JDMainViewController

#pragma mark - Some blocks

void(^block1)(void) = ^{
    NSLog(@"this is block1....");
};

CGFloat(^sum)(CGFloat, CGFloat) = ^(CGFloat number1, CGFloat number2) {
    return number1 + number2;
};

NSString *(^getMessage)(NSString *, NSInteger) = ^(NSString *name, NSInteger age) {
    return [NSString stringWithFormat:@"我叫 %@, 今年 %i 岁", name, age];
};
typedef NSString *(^getMessageHandler)(NSString *, NSInteger);

typedef void(^BlockHandler)(NSString *name, NSInteger age);


#pragma mark - View lifecycle methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (NSString *)getMessageWithHandler:(getMessageHandler)handler
{
    return handler(@"Lisi", 10);
}

- (void)testBlockHandler:(BlockHandler)handler
{
    handler(@"wangwu", 88);
}

- (void)simpleBlockMethods
{
    //  NSInteger outsideNumber = 10;   // outsideNumber 在block中只能读，不能写
    __block NSInteger outsideNumber = 10; // __block 说明变量在block中可读写
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:@"1", @"2", nil];
    [array sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSInteger insideNumber = 20;
        outsideNumber = 90;
        NSLog(@"outsideNumber = %i", outsideNumber);
        NSLog(@"indiseNumber = %i", insideNumber);
        return NSOrderedSame;
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    bgImageView.image = [UIImage imageNamed:@"Default.png"];
    [self.view addSubview:bgImageView];
    [bgImageView release];
    
    // block 相关
    block1();
    
    CGFloat result = sum(5, 3.3);
    NSLog(@"result is %f", result);
    
    NSString *message = getMessage(@"zhangsan", 18);
    NSLog(@"%@", message);
    
    NSString *message1 = [self getMessageWithHandler:getMessage];
    NSLog(@"%@", message1);
    
    [self testBlockHandler:^(NSString *name, NSInteger age) {
        NSLog(@"我叫 %@, 今年 %i 岁", name, age);
    }];
    
    [self simpleBlockMethods];
    
    
    // GCD 相关
    
    // dispatch_get_main_queue 主线程队列，主要用于UI相关任务
    UIButton *mainQueueButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    mainQueueButton.frame = CGRectMake(10, 10, 300, 40);
    [mainQueueButton setTitle:@"dispatch_get_main_queue" forState:UIControlStateNormal];
    [mainQueueButton addTarget:self
                        action:@selector(mainQueueButtonClicked:)
              forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mainQueueButton];
    
    // 处理和UI无关的同步任务，会导致阻塞，少用。
    UIButton *syncDispatchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    syncDispatchButton.frame = CGRectMake(10, 60, 300, 40);
    [syncDispatchButton setTitle:@"dispatch_get_global_queue(同步)" forState:UIControlStateNormal];
    [syncDispatchButton addTarget:self
                        action:@selector(syncDispatchButtonClicked:)
              forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:syncDispatchButton];
    
    // 处理和UI无关的异步任务，很强大，多用。
    UIButton *asyncDispatchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    asyncDispatchButton.frame = CGRectMake(10, 110, 300, 40);
    [asyncDispatchButton setTitle:@"dispatch_get_global_queue(异步)" forState:UIControlStateNormal];
    [asyncDispatchButton addTarget:self
                           action:@selector(asyncDispatchButtonClicked:)
                 forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:asyncDispatchButton];
    
    // 使用GCD延时后执行任务，纳秒级别
    UIButton *afterButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    afterButton.frame = CGRectMake(10, 160, 300, 40);
    [afterButton setTitle:@"延时执行任务（纳秒级）" forState:UIControlStateNormal];
    [afterButton addTarget:self
                    action:@selector(afterButtonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:afterButton];
    
    // 一个任务最多执行一次
    UIButton *onceButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    onceButton.frame = CGRectMake(10, 210, 300, 40);
    [onceButton setTitle:@"一个任务只执行一次，哪怕是多次调用" forState:UIControlStateNormal];
    [onceButton addTarget:self
                    action:@selector(onceButtonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:onceButton];
    
    // 将多个任务放到一个地方，然后全部运行，运行结束后会收到一个通知
    UIButton *groupButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    groupButton.frame = CGRectMake(10, 260, 300, 40);
    [groupButton setTitle:@"任务分组" forState:UIControlStateNormal];
    [groupButton addTarget:self
                   action:@selector(groupButtonClicked:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:groupButton];
    
    // 创建自己的独特的分派队列, 先进先出（FIFO）
    UIButton *specialButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    specialButton.frame = CGRectMake(10, 310, 300, 40);
    [specialButton setTitle:@"GCD构建自己的分派队列" forState:UIControlStateNormal];
    [specialButton addTarget:self
                    action:@selector(specialButtonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:specialButton];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 360, 300, self.view.frame.size.height - 370)];
    _imageView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:_imageView];
    [_imageView release];
}

#pragma mark - Custom event methods

typedef struct
{
    char *title;
    char *message;
    char *cancelButtonTitle;
}AlertViewData;

void displayAlertView(void *alertData) {
    AlertViewData *data = (AlertViewData *)alertData;
    NSString *title = [NSString stringWithUTF8String:data->title];
    NSString *message = [NSString stringWithUTF8String:data->message];
    NSString *cancelButtonTitle = [NSString stringWithUTF8String:data->cancelButtonTitle];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    
    NSLog(@"Current thread = %@", [NSThread currentThread]);
    NSLog(@"Main thread = %@", [NSThread mainThread]);
}

- (void)mainQueueButtonClicked:(id)sender
{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"GCD"
                                                        message:@"dispatch_get_main_queue\n 用于更新UI \n 只能用dispatch_async函数"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        NSLog(@"Current thread = %@", [NSThread currentThread]);
        NSLog(@"Main thread = %@", [NSThread mainThread]);
    });
    
    
//    AlertViewData *alertData = (AlertViewData *)malloc(sizeof(AlertViewData));
//    if (alertData != NULL) {
//        alertData->title = "GCD";
//        alertData->message = "dispatch_get_main_queue\n 用于更新UI \n 只能用dispatch_async函数";
//        alertData->cancelButtonTitle = "OK";
//        dispatch_async_f(mainQueue, (void *)alertData, displayAlertView);
//    }
}

void(^printHandler)(void) = ^{
    for(int i = 1; i <= 1000; i++)
    {
        NSLog(@"i = %i, main thread = %@, current thread = %@", i, [NSThread mainThread], [NSThread currentThread]);
    }
};

void printFunction(void *parameter)
{
    for(int i = 1; i <= 1000; i++)
    {
        NSLog(@"i = %i, main thread = %@, current thread = %@", i, [NSThread mainThread], [NSThread currentThread]);
    }
}

- (void)syncDispatchButtonClicked:(id)sender
{
    // dispatch_sync 函数使用当前线程，分配任务时的线程。
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(concurrentQueue, printHandler);
    dispatch_sync(concurrentQueue, printHandler);
    
//    dispatch_sync_f(concurrentQueue, NULL, printFunction);
//    dispatch_sync_f(concurrentQueue, NULL, printFunction);
}

- (void)asyncDispatchButtonClicked:(id)sender
{
    _imageView.image = nil;
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{
        __block UIImage *image = nil;
        dispatch_sync(concurrentQueue, ^{
            NSString *urlString = @"http://www.apple.com.cn/home/images/billboard_iphone_hero.jpg";
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
            image = [UIImage imageWithData:imageData];
        });
        dispatch_sync(dispatch_get_main_queue(), ^{
            _imageView.image = image;
        });
    });
}

- (void)afterButtonClicked:(id)sender
{
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"dispatch_after"
                                                        message:@"纳秒级别，牛逼！"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    });
    
//    dispatch_after_f(<#dispatch_time_t when#>, <#dispatch_queue_t queue#>, <#void *context#>, <#dispatch_function_t work#>)
}


void(^executeOnlyOnce)(void) = ^{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"execute only once"
                                                    message:@"我只显示一次，您再也见不到我了！"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
};

- (void)onceButtonClicked:(id)sender
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_async(dispatch_get_main_queue(), executeOnlyOnce);
    });
}

- (void)method1
{
    for (int i = 0; i < 10; i++) {
        NSLog(@"%s, i = %i", __FUNCTION__, i);
    }
}

- (void)method2
{
    for (int i = 0; i < 10; i++) {
        NSLog(@"%s, i = %i", __FUNCTION__, i);
    }
}

- (void)method3
{
    for (int i = 0; i < 10; i++) {
        NSLog(@"%s, i = %i", __FUNCTION__, i);
    }
}

- (void)groupButtonClicked:(id)sender
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group, globalQueue, ^{
        [self method1];
        NSLog(@"current thread = %@", [NSThread currentThread]);
    });
    dispatch_group_async(group, globalQueue, ^{
        [self method2];
        NSLog(@"current thread = %@", [NSThread currentThread]);
    });
    dispatch_group_async(group, globalQueue, ^{
        [self method3];
        NSLog(@"current thread = %@", [NSThread currentThread]);
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"GCD 分组任务"
                                                        message:@"分组的所有任务都执行完毕！"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    });
}

- (void)specialButtonClicked:(id)sender
{
    dispatch_queue_t firstSerialQueue = dispatch_queue_create("com.jd.gcd.serialQueue1", 0);
    dispatch_async(firstSerialQueue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"First, i = %i, mainT: %@, currentT: %@", i, [NSThread mainThread], [NSThread currentThread]);
        }
    });
    
    dispatch_async(firstSerialQueue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"Second, i = %i, mainT: %@, currentT: %@", i, [NSThread mainThread], [NSThread currentThread]);
        }
    });
    
    dispatch_async(firstSerialQueue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"Third, i = %i, mainT: %@, currentT: %@", i, [NSThread mainThread], [NSThread currentThread]);
        }
    });
}




#pragma mark - Memroy management methods

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [super dealloc];
}

@end
