//
//  BLLoginRequest.m
//  BLDemo05
//
//  Created by derek on 15/7/25.
//  Copyright (c) 2015年 derek. All rights reserved.
//

#import "BLLoginRequest.h"
#import "BLMultipartForm.h"
#import "BLLoginRequestParser.h"

@interface BLLoginRequest()<NSURLConnectionDataDelegate>

@end

@implementation BLLoginRequest

- (void)sendLoginRequestWithUserName:(NSString *)userName
                            password:(NSString *)password
                            delegate:(id<BLLoginRequestDelegate>)delegate
{
    [self.URLConnection cancel];
    
    
    self.delegate = delegate;
    NSString *URLString = @"http://192.168.199.141/xampp/bl/login.xml";
    
//    // GET  eg, http://xxxx.com/login.json?username=zhangsan&password=123456
//    URLString = [NSString stringWithFormat:@"%@?username=%@&password=%@", URLString, userName, password];
//    NSString *encodedURLString
//    = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *URL = [NSURL URLWithString:encodedURLString];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
//    request.HTTPMethod = @"GET";
//    request.timeoutInterval = 60;
//    request.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
//    self.URLConnection = [[NSURLConnection alloc] initWithRequest:request
//                                                         delegate:self
//                                                 startImmediately:YES];
    
    // POST
    NSString *encodedURLString
    = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:encodedURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 60;
    request.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    BLMultipartForm *form = [[BLMultipartForm alloc] init];
    [form addValue:userName forField:@"username"];
    [form addValue:password forField:@"password"];
    request.HTTPBody = [form httpBody];
    self.URLConnection = [[NSURLConnection alloc] initWithRequest:request
                                                         delegate:self
                                                 startImmediately:YES];

}

//- (void)start
//{
//    [self.URLConnection start];
//}

- (void)cancelRequest
{
    if (self.URLConnection) {
        [self.URLConnection cancel];
        self.URLConnection = nil;
    }
}

#pragma mark - NSURLConnectionDataDelegate methods

- (void)connection:(NSURLConnection *)connection
    didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if (httpResponse.statusCode == 200) {   // 连接成功
        self.receivedData = [NSMutableData data];
    }else {
        // 请求错误，错误处理。
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *string = [[NSString alloc] initWithData:self.receivedData
                                             encoding:NSUTF8StringEncoding];
    NSLog(@"%@", string);
    
    BLLoginRequestParser *parser = [[BLLoginRequestParser alloc] init];
//    BLUser *user = [parser parseJson:self.receivedData];
    BLUser *user = [parser parseXML:self.receivedData];
    if ([_delegate respondsToSelector:@selector(requestSuccess:user:)]) {
        [_delegate requestSuccess:self user:user];
    }
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
    if ([_delegate respondsToSelector:@selector(requestFailed:error:)]) {
        [_delegate requestFailed:self error:error];
    }
}

@end
