//
//  BLImageDownloader.h
//  BLDemo05
//
//  Created by derek on 15/7/25.
//  Copyright (c) 2015年 derek. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BLImageDownloaderDelegate;

@interface BLImageDownloader : NSObject

@property(nonatomic, strong)NSURLConnection *URLConnection;
@property(nonatomic, strong)NSMutableData *receivedData;
@property(nonatomic, assign)long long totalLength;
@property(nonatomic, assign)id<BLImageDownloaderDelegate> delegate;

- (void)download:(NSString *)URLString
        delegate:(id<BLImageDownloaderDelegate>)delegate;

- (void)cancel;

@end


@protocol BLImageDownloaderDelegate <NSObject>

- (void)downloadSuccess:(BLImageDownloader *)downloader data:(NSData *)data;
- (void)downloadFailed:(BLImageDownloader *)downloader error:(NSError *)error;
- (void)downloadReceivedData:(BLImageDownloader *)downloader;

@end
