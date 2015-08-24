//
//  BLUserSpaceViewController.h
//  BLTableViewDemo
//
//  Created by 松 段 on 11-11-10.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLMessage;

@interface BLUserSpaceViewController : UIViewController {
    BLMessage       *_message;
}

@property (nonatomic, retain) BLMessage *message;

@end
