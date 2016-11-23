//
//  SDWebImageDownloaderOperation+SSL.m
//  Jiazheng
//
//  Created by fengfei on 16/9/28.
//  Copyright © 2016年 58. All rights reserved.
//
#import "JRSwizzle.h"
#import "NSURLRequest+DJTrustSSL.h"
@implementation NSURLRequest (NSURLRequestWithIgnoreSSL)
static BOOL DJallowsAnyHTTPSCertificateForHost = YES;

+ (void)openTrustSSL {
    [[NSURLRequest class]  jr_swizzleClassMethod:@selector(allowsAnyHTTPSCertificateForHost:) withClassMethod:@selector(dj_allowsAnyHTTPSCertificateForHost:) error:nil];
}

+ (void)closeTrustSSL {
    [[NSURLRequest class]  jr_swizzleClassMethod:@selector(dj_allowsAnyHTTPSCertificateForHost:) withClassMethod:@selector(allowsAnyHTTPSCertificateForHost:) error:nil];
}

+ (BOOL)dj_allowsAnyHTTPSCertificateForHost:(NSString *)host {
    BOOL resu = [self dj_allowsAnyHTTPSCertificateForHost:host];
    if(DJallowsAnyHTTPSCertificateForHost){
         return [NSURLRequest dj58TrustHost:host];
    }else{
        return resu;
    }
}
+(void)dj58DisableAllowsAnyHTTPSCertificateForHost{
    DJallowsAnyHTTPSCertificateForHost = NO;
}

+(BOOL)dj58TrustHost:(NSString *)host{
    return YES;
}
@end
