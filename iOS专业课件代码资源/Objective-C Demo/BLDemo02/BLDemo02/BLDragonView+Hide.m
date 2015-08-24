//
//  BLDragonView+Hide.m
//  BLDemo02
//
//  Created by derek on 6/26/15.
//  Copyright (c) 2015 derek. All rights reserved.
//

#import "BLDragonView+Hide.h"

@implementation BLDragonView (Hide)

- (void)hideOrShow
{
    self.dragonImageView.hidden = !self.dragonImageView.hidden;
}

@end
