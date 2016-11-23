//
//  DJDebugURLProtocol.h
//  SuYun
//
//  Created by iBlock on 16/9/1.
//  Copyright © 2016年 58. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DJDebugProtocolModel : NSObject

+ (DJDebugProtocolModel *)shareInstance;
- (void)syncUserdefault;
@property (nonatomic, strong, readonly) NSMutableDictionary *errorApiList;

@end

@interface DJDebugURLProtocol : NSURLProtocol

+ (void)updateURLProtocol;

@end
