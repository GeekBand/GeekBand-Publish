//
//  ViewController.h
//  BLTableViewDemo
//
//  Created by derek on 7/10/15.
//  Copyright (c) 2015 derek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLCustomCell.h"

@interface BLMessageListViewController : UIViewController < UITableViewDelegate,
UITableViewDataSource, BLCustomCellDelegate > {
    UITableView         *_tableView;
    NSMutableArray      *_messageArray;
}

- (void)createMessageData;

@end

