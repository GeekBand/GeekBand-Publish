//
//  JDAppDelegate.h
//  JDCoreData
//
//  Created by 段 松 on 13-6-6.
//  Copyright (c) 2013年 duansong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// 程序员和管理对象模式之间的桥梁，做数据库的增删改查等操作
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

// 数据库里的不同管理对象类型
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;

// 数据库文件和程序之间的联系桥梁
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end










