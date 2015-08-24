//
//  BLSqliteViewController.h
//  BLDataSaveDemo
//
//  Created by duansong on 15-7-14.
//  Copyright 2015 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BLSqliteViewController : UIViewController < UITableViewDelegate, UITableViewDataSource > {
	NSMutableArray		*_poemArray;
}

@property (nonatomic, weak) IBOutlet UITableView *poemTableView;
@property (nonatomic, weak) IBOutlet UIButton *createDBButton;
@property (nonatomic, weak) IBOutlet UIButton *addPoemToDBButton;
@property (nonatomic, weak) IBOutlet UIButton *queryPoemFromDBButton;
@property (nonatomic, weak) IBOutlet UIButton *modifyPoemInDBButton;
@property (nonatomic, weak) IBOutlet UIButton *deletePoemFromDBButton;

- (IBAction) createDBButtonClicked:(id)sender;
- (IBAction) addPoemToDBButtonClicked:(id)sender;
- (IBAction) queryPoemFromDBButtonClicked:(id)sender;
- (IBAction) modifyPoemInDBButtonClicked:(id)sender;
- (IBAction) deletePoemFromDBButtonClicked:(id)sender;

- (void) initVariables;
- (void) initComponents;
- (NSMutableArray *)getPoems;

@end
