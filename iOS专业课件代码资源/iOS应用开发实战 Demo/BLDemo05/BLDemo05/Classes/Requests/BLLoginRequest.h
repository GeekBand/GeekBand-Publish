//
//  BLLoginRequest.h
//  BLDemo05
//
//  Created by derek on 15/7/25.
//  Copyright (c) 2015年 derek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLUser.h"

@class BLLoginRequest;

@protocol BLLoginRequestDelegate <NSObject>

- (void)requestSuccess:(BLLoginRequest *)request user:(BLUser *)usr;
- (void)requestFailed:(BLLoginRequest *)request error:(NSError *)error;

@end

@interface BLLoginRequest : NSObject

@property(nonatomic, strong)NSURLConnection *URLConnection;
@property(nonatomic, strong)NSMutableData *receivedData;
@property(nonatomic, assign)id<BLLoginRequestDelegate> delegate;

- (void)sendLoginRequestWithUserName:(NSString *)userName
                            password:(NSString *)password
                            delegate:(id<BLLoginRequestDelegate>)delegate;

- (void)cancelRequest;

@end
