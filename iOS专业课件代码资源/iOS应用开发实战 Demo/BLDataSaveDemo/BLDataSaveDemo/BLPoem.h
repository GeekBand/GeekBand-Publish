//
//  BLModelPoem.h
//  BLDataSaveDemo
//
//  Created by duansong on 15-7-14.
//  Copyright 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BLPoem : NSObject {
	NSInteger			_poemId;
	NSString			*_poemName;
	NSString			*_poetName;
	NSString			*_poemContent;
	BOOL				_whetherFavorite;
}

@property (nonatomic, assign) NSInteger		poemId;
@property (nonatomic, retain) NSString		*poemName;
@property (nonatomic, retain) NSString		*poetName;
@property (nonatomic, retain) NSString		*poemContent;
@property (nonatomic, assign) BOOL			whetherFavorite;

@end
