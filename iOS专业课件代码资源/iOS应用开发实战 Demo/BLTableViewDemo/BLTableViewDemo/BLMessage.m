//
//  BLMessage.m
//  BLTableViewDemo
//
//  Created by 松 段 on 11-11-10.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "BLMessage.h"

@implementation BLMessage

@synthesize sender      = _sender;
@synthesize text        = _text;
@synthesize sendDate    = _sendDate;

+ (BLMessage *)messageWithSender:(BLUser *)aSender text:(NSString *)aText sendDate:(NSDate *)aDate {
    BLMessage *message = [[BLMessage alloc] init];
    message.sender = aSender;
    message.text = aText;
    message.sendDate = aDate;
    return message;
}

- (void)dealloc {
    self.sender     = nil;
    self.text       = nil;
    self.sendDate   = nil;
}


@end
