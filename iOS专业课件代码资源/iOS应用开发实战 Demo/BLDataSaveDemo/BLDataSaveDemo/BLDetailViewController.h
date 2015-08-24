//
//  BLDetailViewController.h
//  BLDataSaveDemo
//
//  Created by duansong on 15-7-14.
//  Copyright 2015 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLPoem.h"

@interface BLDetailViewController : UIViewController {
	BLPoem					*_poem;
	UIBarButtonItem			*_favoriteButton;
}

@property (nonatomic, retain) BLPoem *poem;

- (void) initComponents;

@end
