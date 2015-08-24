//
//  BLLoginRequestParser.h
//  BLDemo05
//
//  Created by derek on 15/7/25.
//  Copyright (c) 2015年 derek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLUser.h"

@interface BLLoginRequestParser : NSObject<NSXMLParserDelegate>
{
    BLAddress           *_address;
    BLUser              *_user;
    NSMutableString     *_currentValue;
}

- (BLUser *)parseJson:(NSData *)data;

- (BLUser *)parseXML:(NSData *)data;

@end
