//
//  JDMainViewController.m
//  JDCoreData
//
//  Created by 段 松 on 13-6-6.
//  Copyright (c) 2013年 duansong. All rights reserved.
//

#import "JDMainViewController.h"
#import "JDAppDelegate.h"
#import "JDPoem.h"
#import "JDPoet.h"

@interface JDMainViewController ()

@end

@implementation JDMainViewController

#pragma mark - View lifecycle methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    bgImageView.image = [UIImage imageNamed:@"Default.png"];
    [self.view addSubview:bgImageView];
    [bgImageView release];
    
    UIButton *savePoetButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    savePoetButton.frame = CGRectMake(10, 10, 300, 40);
    [savePoetButton setTitle:@"save poet to db" forState:UIControlStateNormal];
    [savePoetButton addTarget:self action:@selector(savePoetButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:savePoetButton];
    
    UIButton *fetchPoetButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    fetchPoetButton.frame = CGRectMake(10, 60, 300, 40);
    [fetchPoetButton setTitle:@"fetch poet from db" forState:UIControlStateNormal];
    [fetchPoetButton addTarget:self action:@selector(fetchPoetButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fetchPoetButton];
    
    UIButton *deletePoetButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    deletePoetButton.frame = CGRectMake(10, 110, 300, 40);
    [deletePoetButton setTitle:@"delete poet from db" forState:UIControlStateNormal];
    [deletePoetButton addTarget:self action:@selector(deletePoetButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deletePoetButton];
    
    UIButton *sortPoetButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sortPoetButton.frame = CGRectMake(10, 160, 300, 40);
    [sortPoetButton setTitle:@"sort poet from db" forState:UIControlStateNormal];
    [sortPoetButton addTarget:self action:@selector(sortPoetButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sortPoetButton];

    UIButton *savePoemButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    savePoemButton.frame = CGRectMake(10, 210, 300, 40);
    [savePoemButton setTitle:@"save poem to db" forState:UIControlStateNormal];
    [savePoemButton addTarget:self action:@selector(savePoemButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:savePoemButton];
    
    UIButton *fetchPoemButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    fetchPoemButton.frame = CGRectMake(10, 260, 300, 40);
    [fetchPoemButton setTitle:@"fetch poem from db" forState:UIControlStateNormal];
    [fetchPoemButton addTarget:self action:@selector(fetchPoemButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fetchPoemButton];
    
    UIButton *deletePoemButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    deletePoemButton.frame = CGRectMake(10, 310, 300, 40);
    [deletePoemButton setTitle:@"delete poem from db" forState:UIControlStateNormal];
    [deletePoemButton addTarget:self action:@selector(deletePoemButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deletePoemButton];
}

#pragma mark - Custom event methods

- (void)savePoetButtonClicked:(id)sender
{
    JDAppDelegate *appDelegate = (JDAppDelegate *)[UIApplication sharedApplication].delegate;
    JDPoet *poet = [NSEntityDescription insertNewObjectForEntityForName:@"JDPoet"
                                                 inManagedObjectContext:appDelegate.managedObjectContext];
    if (poet != nil) {
        srandom(time(nil));
        NSInteger randomNumber = random() % 100 + 1;
        poet.name = [NSString stringWithFormat:@"李白%i", randomNumber];
        
        NSInteger randomAge = random() % 80 + 1;
        poet.age = [NSNumber numberWithInteger:randomAge];
        
        NSError *error = nil;
        NSString *alertMessage = nil;
        if ([appDelegate.managedObjectContext save:&error]) { // 一定不要忘记保存。
            alertMessage = @"保存数据到DB成功";
        }else {
            alertMessage = [NSString stringWithFormat:@"保存数据到DB失败\n%@", error];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:alertMessage
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)fetchPoetButtonClicked:(id)sender
{
    JDAppDelegate *appDelegate = (JDAppDelegate *)[UIApplication sharedApplication].delegate;

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity
    = [NSEntityDescription entityForName:@"JDPoet" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *poets = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [fetchRequest release];
    
    NSMutableString *alertMessage = [[NSMutableString alloc] init];
    if ([poets count] > 0) {
        for (JDPoet *poet in poets) {
            [alertMessage appendFormat:@"%@ %i\n", poet.name, [poet.age integerValue]];
        }
    }else {
        [alertMessage setString:@"没有找到任何poet"];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:alertMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    [alertMessage release];
}

- (void)deletePoetButtonClicked:(id)sender
{
    JDAppDelegate *appDelegate = (JDAppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity
    = [NSEntityDescription entityForName:@"JDPoet" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *poets = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [fetchRequest release];
    
    NSMutableString *alertMessage = [[NSMutableString alloc] init];
    if ([poets count] > 0) {
        for (JDPoet *poet in poets) {
            [appDelegate.managedObjectContext deleteObject:poet];
            if ([poet isDeleted]) {
                [alertMessage appendFormat:@"%@ %i 已经删除！\n", poet.name, [poet.age integerValue]];
            }
        }
    }else {
        [alertMessage setString:@"没有找到任何poet"];
    }
    
    if ([appDelegate.managedObjectContext save:&error]) {
        
    }else {
        [alertMessage setString:@"保存数据库失败"];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:alertMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    [alertMessage release];
}

- (void)sortPoetButtonClicked:(id)sender
{
    JDAppDelegate *appDelegate = (JDAppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSSortDescriptor *nameSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSSortDescriptor *ageSort = [[NSSortDescriptor alloc] initWithKey:@"age" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:nameSort, ageSort, nil];
    [nameSort release];
    [ageSort release];
    
    fetchRequest.sortDescriptors = sortDescriptors;
    NSEntityDescription *entity
    = [NSEntityDescription entityForName:@"JDPoet" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *poets = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [fetchRequest release];
    
    NSMutableString *alertMessage = [[NSMutableString alloc] init];
    if ([poets count] > 0) {
        for (JDPoet *poet in poets) {
            [alertMessage appendFormat:@"%@ %i\n", poet.name, [poet.age integerValue]];
        }
    }else {
        [alertMessage setString:@"没有找到任何poet"];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:alertMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    [alertMessage release];
}

- (void)savePoemButtonClicked:(id)sender
{
    JDAppDelegate *appDelegate = (JDAppDelegate *)[UIApplication sharedApplication].delegate;
    JDPoem *poem = [NSEntityDescription insertNewObjectForEntityForName:@"JDPoem"
                                                 inManagedObjectContext:appDelegate.managedObjectContext];
    if (poem != nil) {
        poem.content = @"白日依山尽，黄河入河流。欲穷千里目，更上一层楼。";
        poem.favorite = [NSNumber numberWithBool:NO];
        
        JDPoet *poet = [NSEntityDescription insertNewObjectForEntityForName:@"JDPoet"
                                                     inManagedObjectContext:appDelegate.managedObjectContext];
        poet.name = @"李白";
        poet.age = [NSNumber numberWithInt:88];
        poem.poet = poet;
        
        NSError *error = nil;
        NSString *alertMessage = nil;
        if ([appDelegate.managedObjectContext save:&error]) { // 一定不要忘记保存。
            alertMessage = @"保存数据到DB成功";
        }else {
            alertMessage = [NSString stringWithFormat:@"保存数据到DB失败\n%@", error];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:alertMessage
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)fetchPoemButtonClicked:(id)sender
{
    JDAppDelegate *appDelegate = (JDAppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity
    = [NSEntityDescription entityForName:@"JDPoem" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *poems = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [fetchRequest release];
    
    NSMutableString *alertMessage = [[NSMutableString alloc] init];
    if ([poems count] > 0) {
        for (JDPoem *poem in poems) {
            [alertMessage appendFormat:@"%@\n%i\n%@", poem.poet.name, [poem.poet.age integerValue], poem.content];
        }
    }else {
        [alertMessage setString:@"没有找到任何poet"];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:alertMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    [alertMessage release];
}

- (void)deletePoemButtonClicked:(id)sender
{
    JDAppDelegate *appDelegate = (JDAppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity
    = [NSEntityDescription entityForName:@"JDPoem" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *poems = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [fetchRequest release];
    
    NSMutableString *alertMessage = [[NSMutableString alloc] init];
    if ([poems count] > 0) {
        for (JDPoem *poem in poems) {
            [appDelegate.managedObjectContext deleteObject:poem];
            if ([poem isDeleted]) {
                [alertMessage appendFormat:@"%@\n已经删除！", poem.content];
            }
        }
    }else {
        [alertMessage setString:@"没有找到任何poem"];
    }
    
    if ([appDelegate.managedObjectContext save:&error]) {
        
    }else {
        [alertMessage setString:@"保存数据库失败"];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:alertMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    [alertMessage release];
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
