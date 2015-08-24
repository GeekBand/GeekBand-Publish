//
//  BLModelPoem.m
//  BLDataSaveDemo
//
//  Created by duansong on 15-7-14.
//  Copyright 2015 __MyCompanyName__. All rights reserved.
//

#import "BLPoem.h"


@implementation BLPoem

@synthesize poemId				= _poemId;
@synthesize poemName			= _poemName;
@synthesize poetName			= _poetName;
@synthesize poemContent			= _poemContent;
@synthesize whetherFavorite		= _whetherFavorite;

- (void) dealloc {
	self.poemName		= nil;
	self.poetName		= nil;
	self.poemContent	= nil;
}

@end
