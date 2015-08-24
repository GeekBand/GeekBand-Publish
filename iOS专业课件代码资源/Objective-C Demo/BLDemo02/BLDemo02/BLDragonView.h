//
//  BLDragonView.h
//  BLDemo02
//
//  Created by derek on 6/9/15.
//  Copyright (c) 2015 derek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLDragonViewDelegate.h"

//@class BLDragonView;
//
//@protocol BLDragonViewDelegate <NSObject>
//
//@optional
//- (void)backButtonClicked:(BLDragonView *)dragonView;
//
//@required
//- (void)forwardButtonClicked:(BLDragonView *)dragonView;
//
//@end
//

@interface BLDragonView : UIView

@property(nonatomic, copy, readonly)NSString *name;
@property(nonatomic, strong)UIImageView *dragonImageView;
@property(nonatomic, weak)id<BLDragonViewDelegate> delegate;

@end



