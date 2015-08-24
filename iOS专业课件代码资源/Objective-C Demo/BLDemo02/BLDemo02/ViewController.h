//
//  ViewController.h
//  BLDemo02
//
//  Created by derek on 6/9/15.
//  Copyright (c) 2015 derek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLDragonViewDelegate.h"
#import "BLDragonView.h"

@interface ViewController : UIViewController<BLDragonViewDelegate>
{
    UILabel         *_dragonStatusLabel;
    BLDragonView    *_dragonView;
}


@end

