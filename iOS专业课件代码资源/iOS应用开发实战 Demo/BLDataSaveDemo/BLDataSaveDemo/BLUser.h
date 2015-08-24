//
//  BLUser.h
//  BLDataSaveDemo
//
//  Created by duansong on 11-5-21.
//  Copyright 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLPoem.h"


@interface BLUser : NSObject < NSCoding > {
	NSString			*_userName;
	NSString			*_email;
	NSString			*_password;
	NSInteger			_age;
}

@property (nonatomic, retain) NSString	*userName;
@property (nonatomic, retain) NSString  *email;
@property (nonatomic, retain) NSString	*password;
@property (nonatomic, assign) NSInteger age;

@end
