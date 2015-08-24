//
//  BLImageDownloader.m
//  BLDemo05
//
//  Created by derek on 15/7/25.
//  Copyright (c) 2015年 derek. All rights reserved.
//

#import "BLImageDownloader.h"

@interface BLImageDownloader()<NSURLConnectionDataDelegate>

@end

@implementation BLImageDownloader

- (void)download:(NSString *)URLString delegate:(id<BLImageDownloaderDelegate>)delegate
{
    [self cancel];
    
    self.delegate = delegate;
    NSString *encodedURLString
    = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:encodedURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    self.URLConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
//    [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
}

- (void)cancel
{
    if (self.URLConnection) {
        [self.URLConnection cancel];
    }
    self.URLConnection = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpURLResponse = (NSHTTPURLResponse *)response;
    if (httpURLResponse.statusCode == 200) {
        self.totalLength = httpURLResponse.expectedContentLength;
        self.receivedData = [NSMutableData data];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
    if ([_delegate respondsToSelector:@selector(downloadReceivedData:)]) {
        [_delegate downloadReceivedData:self];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if ([_delegate respondsToSelector:@selector(downloadSuccess:data:)]) {
        [_delegate downloadSuccess:self data:self.receivedData];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if ([_delegate respondsToSelector:@selector(downloadFailed:error:)]) {
        [_delegate downloadFailed:self error:error];
    }
}

@end
