//
//  BLDetailViewController.m
//  BLDataSaveDemo
//
//  Created by duansong on 15-7-14.
//  Copyright 2015 __MyCompanyName__. All rights reserved.
//

#import "BLDetailViewController.h"
#import "BLPoemDB.h"

@implementation BLDetailViewController

@synthesize poem = _poem;

#pragma mark -
#pragma mark about view methods

- (void)viewDidLoad {
	[self initComponents];
    [super viewDidLoad];
}

- (void) initComponents {
	self.title = @"唐诗";
    
    self.view.backgroundColor = [UIColor whiteColor];
	
	NSString *favoriteButtonTitle = @"添加收藏";
	if (self.poem.whetherFavorite == YES) {
		favoriteButtonTitle = @"删除收藏";
	}
	_favoriteButton = [[UIBarButtonItem alloc] initWithTitle:favoriteButtonTitle style:UIBarButtonItemStylePlain target:self action:@selector(favoriteButtonClicked:)];
	self.navigationItem.rightBarButtonItem = _favoriteButton;
	
	UILabel *poemNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 74, self.view.bounds.size.width, 20)];
	poemNameLabel.backgroundColor = [UIColor clearColor];
	poemNameLabel.font = [UIFont systemFontOfSize:15.0f];
	poemNameLabel.textAlignment = NSTextAlignmentCenter;
	poemNameLabel.textColor = [UIColor blackColor];
	poemNameLabel.text = self.poem.poemName;
	[self.view addSubview:poemNameLabel];
	
	UILabel *poetNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 104, self.view.bounds.size.width, 20)];
	poetNameLabel.backgroundColor = [UIColor clearColor];
	poetNameLabel.font = [UIFont systemFontOfSize:15.0f];
	poetNameLabel.textAlignment = NSTextAlignmentCenter;
	poetNameLabel.textColor = [UIColor blackColor];
	poetNameLabel.text = self.poem.poetName;
	[self.view addSubview:poetNameLabel];

	
	UILabel *poemContenLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	poemContenLabel.backgroundColor = [UIColor clearColor];
	poemContenLabel.font = [UIFont systemFontOfSize:14.0f];
	poemContenLabel.textAlignment = NSTextAlignmentCenter;
	poemContenLabel.textColor = [UIColor blackColor];
	poemContenLabel.text = self.poem.poemContent;
	poemContenLabel.numberOfLines = 0;
	poemContenLabel.lineBreakMode = NSLineBreakByWordWrapping;
	[self.view addSubview:poemContenLabel];
	
    CGSize poemContenSize = [self.poem.poemContent boundingRectWithSize:CGSizeMake(self.view.bounds.size.width, CGFLOAT_MAX)
                                               options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14], }
                                               context:nil].size;

    
    
	poemContenLabel.frame = CGRectMake(0, 130, self.view.bounds.size.width, poemContenSize.height);
}


#pragma mark -
#pragma mark custom event methods

- (void) favoriteButtonClicked:(id)sender {
	BLPoemDB *poemDB = [[BLPoemDB alloc] init];
	if (self.poem.whetherFavorite == YES) {		//	删除收藏 
		BOOL result = [poemDB setFavorite:NO favoriteId:self.poem.poemId];
		if (result) {
			self.poem.whetherFavorite = NO;
			_favoriteButton.title = @"添加收藏";
		}
	}else {										//	添加收藏
		BOOL result = [poemDB setFavorite:YES favoriteId:self.poem.poemId];
		if (result) {
			self.poem.whetherFavorite = YES;
			_favoriteButton.title = @"删除收藏";
		}
	}
}


#pragma mark -
#pragma mark memory management methods

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	self.poem			= nil;
}


@end
