//
//  BLLoginRequestParser.m
//  BLDemo05
//
//  Created by derek on 15/7/25.
//  Copyright (c) 2015年 derek. All rights reserved.
//

#import "BLLoginRequestParser.h"

@implementation BLLoginRequestParser

- (BLUser *)parseXML:(NSData *)data
{
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    NSError *error = [parser parserError];
    if (error) {
        
    }else {
        _currentValue = [NSMutableString string];
        _user = [[BLUser alloc] init];
        parser.delegate = self;
        [parser parse];
        return _user;
    }
    return nil;
}

#pragma mark - NSXMLParserDelegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    [_currentValue setString:@""];
    if ([elementName isEqualToString:@"address"]) {
        _address = [[BLAddress alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"userName"]) {
        _user.userName = _currentValue;
    }else if ([elementName isEqualToString:@"age"]) {
        _user.age = [_currentValue integerValue];
    }else if ([elementName isEqualToString:@"headImageUrl"]) {
        _user.headImageUrl = _currentValue;
    }else if ([elementName isEqualToString:@"address"]) {
        _user.address = _address;
        _address = nil;
    }else if ([elementName isEqualToString:@"city"]) {
        _address.city = _currentValue;
    }else if ([elementName isEqualToString:@"id"]) {
        if (_address) {
            _address.cityId = _currentValue;
        }else {
            _user.userId = _currentValue;
        }
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [_currentValue setString:string];
}




- (BLUser *)parseJson:(NSData *)data
{
    NSError *error = nil;
    id jsonDic = [NSJSONSerialization JSONObjectWithData:data
                                                 options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        // 解析出错。
    }else {
        if ([[jsonDic class] isSubclassOfClass:[NSDictionary class]]) {
            
            id userDic = [jsonDic valueForKey:@"user"];
            if ([[userDic class] isSubclassOfClass:[NSDictionary class]]) {
                BLUser *user = [[BLUser alloc] init];
                
                id userName = [userDic valueForKey:@"userName"];
                if ([[userName class] isSubclassOfClass:[NSString class]]) {
                    user.userName = (NSString *)userName;
                }
                
                id userId = [userDic valueForKey:@"id"];
                if ([[userId class] isSubclassOfClass:[NSString class]]) {
                    user.userId = (NSString *)userId;
                }else if ([[userId class] isSubclassOfClass:[NSNumber class]]) {
                    user.userId = [(NSNumber *)userId stringValue];
                }
                
                id age = [userDic valueForKey:@"age"];
                if ([[age class] isSubclassOfClass:[NSNumber class]]) {
                    user.age = [(NSNumber *)age integerValue];
                }

                id headImageUrl = [userDic valueForKey:@"headImageUrl"];
                if ([[headImageUrl class] isSubclassOfClass:[NSString class]]) {
                    user.headImageUrl = (NSString *)headImageUrl;
                }

                id addressDic = [userDic valueForKey:@"address"];
                if ([[addressDic class] isSubclassOfClass:[NSDictionary class]]) {
                    BLAddress *address = [[BLAddress alloc] init];
                    
                    id city = [addressDic valueForKey:@"city"];
                    if ([[city class] isSubclassOfClass:[NSString class]]) {
                        address.city = city;
                    }
                    id cityId = [addressDic valueForKey:@"id"];
                    if ([[cityId class] isSubclassOfClass:[NSString class]]) {
                        address.cityId = cityId;
                    }

                    user.address = address;
                }

                return user;
            }
        }
    }
    
    return nil;
}

@end
