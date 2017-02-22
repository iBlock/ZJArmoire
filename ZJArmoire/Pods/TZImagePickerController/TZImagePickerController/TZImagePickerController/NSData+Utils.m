//
//  NSData+Utils.m
//  TZImagePickerController
//
//  Created by iBlock on 2017/2/21.
//  Copyright © 2017年 谭真. All rights reserved.
//

#import "NSData+Utils.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSData (Utils)

- (NSString *)MD5 {
    if (!self.length) {
        NSLog(@"data not be nil");
        return nil;
    }
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(self.bytes, (CC_LONG)self.length, md5Buffer);
    // Convert unsigned char buffer to NSString of hex values
    NSMutableString * output =[NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for (int i = 0 ; i<CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x",md5Buffer[i] ];
    }
    return output;
}

@end
