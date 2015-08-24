//
//  BLMessage.h
//  BLTableViewDemo
//
//  Created by 松 段 on 11-11-10.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLUser.h"

@interface BLMessage : NSObject {
    BLUser      *_sender;
    NSString    *_text;
    NSDate      *_sendDate;
}

@property (nonatomic, retain) BLUser *sender;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, retain) NSDate *sendDate;

+ (BLMessage *)messageWithSender:(BLUser *)aSender text:(NSString *)aText sendDate:(NSDate *)aDate;

@end
