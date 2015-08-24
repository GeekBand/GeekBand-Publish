//
//  BLThreeViewController.h
//  BLDemo03
//
//  Created by derek on 6/28/15.
//  Copyright (c) 2015 derek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLBaseViewController.h"

@interface BLThreeViewController : BLBaseViewController<UIScrollViewDelegate>
{
    UIScrollView            *_scrollView;
    UIPageControl           *_pageControl;
    UIView                  *_contentView;
}

@end
