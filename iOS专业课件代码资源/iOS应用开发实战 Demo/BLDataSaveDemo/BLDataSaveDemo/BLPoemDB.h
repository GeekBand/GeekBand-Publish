//
//  BLPoemDB.h
//  BLDataSaveDemo
//
//  Created by duansong on 15-7-14.
//  Copyright 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "BLPoem.h"

@interface BLPoemDB : NSObject {
	FMDatabase		*_db;
}

- (BOOL) createPoemTable;
- (BOOL) addPoem:(BLPoem *)poem;
- (NSMutableArray *) getAllPoems;
- (NSMutableArray *) getFavoritesPoems;
- (BOOL) setFavorite:(BOOL)favorite favoriteId:(NSInteger)poemId;
- (BOOL) deletePoemWithPoemId:(NSInteger)poemId;

@end
