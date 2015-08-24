//
//  BLDragonViewDelegate.h
//  BLDemo02
//
//  Created by derek on 6/26/15.
//  Copyright (c) 2015 derek. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "BLDragonView.h"

@class BLDragonView;

@protocol BLDragonViewDelegate <NSObject>

@optional
- (void)backButtonClicked:(BLDragonView *)dragonView;

@required
- (void)forwardButtonClicked:(BLDragonView *)dragonView;

@end
