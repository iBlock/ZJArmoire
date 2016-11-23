//
//  SDWebImageDownloaderOperation+SSL.h
//  Jiazheng
//
//  Created by fengfei on 16/9/28.
//  Copyright © 2016年 58. All rights reserved.
//
#import <Foundation/Foundation.h>
@interface NSURLRequest (NSURLRequestWithIgnoreSSL)

+ (void)openTrustSSL;
+ (void)closeTrustSSL;

@end
