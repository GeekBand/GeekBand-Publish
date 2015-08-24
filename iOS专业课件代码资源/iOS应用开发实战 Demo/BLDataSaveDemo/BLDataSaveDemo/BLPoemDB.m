//
//  BLPoemDB.m
//  BLDataSaveDemo
//
//  Created by duansong on 15-7-14.
//  Copyright 2015 __MyCompanyName__. All rights reserved.
//

#import "BLPoemDB.h"
#import "BLUtility.h"

#define BLPOEMDBNAME @"BLPoemDB.sqlite"

@implementation BLPoemDB

-(id) init {
	self = [super init];
	if (self) {
		NSString *dbPath = [BLUtility getPathWithinDocumentDir:BLPOEMDBNAME];
		NSFileManager *fileManager = [NSFileManager defaultManager];
		BOOL existFile = [fileManager fileExistsAtPath:dbPath];
		if (existFile == NO) {
			NSString *poemDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:BLPOEMDBNAME];
			[fileManager copyItemAtPath:poemDBPath toPath:dbPath error:nil];
		}
		_db	 = [[FMDatabase alloc] initWithPath:dbPath];
		if ([_db open] == NO) {
			return nil;
		}
	}
	return self;
}


- (BOOL) createPoemTable {
	[_db beginTransaction];
	BOOL success = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS POEMTABLE ("
					@"ID INTEGER PRIMARY KEY NOT NULL,"
					@"POEMNAME TEXT NOT NULL,"
					@"POETNAME TEXT NOT NULL,"
					@"POEMCONTENT TEXT NOT NULL,"
					@"WHETHERFAVORITE BOOL NOT NULL);"];
	[_db commit];
	
	if(!success || [_db hadError]) {
		[_db rollback];
		return NO;
	}
	return YES;
}

- (BOOL) addPoem:(BLPoem *)poem {
	FMResultSet *rs = [_db executeQuery:@"SELECT ID FROM POEMTABLE WHERE ID=?", [NSNumber numberWithInteger:poem.poemId]];
	if(rs && [rs next]) {
		[rs close];
		return YES;
	}
	[rs close];
	
	[_db beginTransaction];
	NSString *bookMark = nil;		
	BOOL success =  [_db executeUpdate:@"INSERT OR IGNORE INTO POEMTABLE (ID,POEMNAME,POETNAME,POEMCONTENT,WHETHERFAVORITE) VALUES (?,?,?,?,?);",
					 [NSNumber numberWithInteger:poem.poemId],
					 poem.poemName,
					 poem.poetName,
					 poem.poemContent,
					 [NSNumber numberWithBool:poem.whetherFavorite],
					 bookMark];
	[_db commit];
	
	if(!success || [_db hadError]) {
		[_db rollback];
		return NO;
	}
	return YES;
}

- (NSMutableArray *) getAllPoems {	
	NSMutableArray *result = [[NSMutableArray alloc] init];
//	FMResultSet *rs = [_db executeQuery:@"SELECT * FROM POEMTABLE WHERE ID=? AND WHETHERFAVORITE=?", [NSNumber numberWithInt:poem.poemId], [NSNumber numberWithBool:poem.whetherFavorite]];
	FMResultSet *rs = [_db executeQuery:@"SELECT * FROM POEMTABLE"];
	while([rs next]) {
		BLPoem *poem = [[BLPoem alloc] init];
		poem.poemId = [rs intForColumn:@"ID"];
		poem.poemName = [rs	stringForColumn:@"POEMNAME"];
		poem.poetName = [rs stringForColumn:@"POETNAME"];
		poem.poemContent = [rs stringForColumn:@"POEMCONTENT"];
		poem.whetherFavorite = [rs boolForColumn:@"WHETHERFAVORITE"];
		[result addObject:poem];
	}
	[rs close];
	return result;
}

- (NSMutableArray *) getFavoritesPoems {
	NSMutableArray *result = [[NSMutableArray alloc] init];	
	FMResultSet *rs = [_db executeQuery:@"SELECT * FROM POEMTABLE WHERE WHETHERFAVORITE=?", [NSNumber numberWithBool:YES]];
	while([rs next]) {
		BLPoem *poem = [[BLPoem alloc] init];
		poem.poemId = [rs intForColumn:@"ID"];
		poem.poemName = [rs	stringForColumn:@"POEMNAME"];
		poem.poetName = [rs stringForColumn:@"POETNAME"];
		poem.poemContent = [rs stringForColumn:@"POEMCONTENT"];
		poem.whetherFavorite = [rs boolForColumn:@"WHETHERFAVORITE"];
		[result addObject:poem];
	}
	[rs close];
	return result;
}

- (BOOL) setFavorite:(BOOL)favorite favoriteId:(NSInteger)poemId {
	if (_db == nil) {
		return NO;
	}
	[_db beginTransaction];
	BOOL result = [_db executeUpdate:@"UPDATE POEMTABLE SET WHETHERFAVORITE=? WHERE ID=?", [NSNumber numberWithBool:favorite], [NSNumber numberWithInteger:poemId]];
	[_db commit];
	return result;
}

- (BOOL) deletePoemWithPoemId:(NSInteger)poemId {
	[_db beginTransaction];
	BOOL success = [_db executeUpdate:@"DELETE FROM POEMTABLE WHERE ID=?", [NSNumber numberWithInteger:poemId]];
	[_db commit];
	if(!success || [_db hadError]) {
		[_db rollback];
		return NO;
	}
	return YES;
}

- (void) dealloc {
	[_db	close];
	_db		= nil;
}

@end
