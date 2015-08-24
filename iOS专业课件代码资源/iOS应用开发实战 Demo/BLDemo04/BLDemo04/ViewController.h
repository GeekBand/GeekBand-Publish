//
//  ViewController.h
//  BLDemo04
//
//  Created by derek on 7/10/15.
//  Copyright (c) 2015 derek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
{
    UITableView     *_tableView;
}


@end

