//
//  UIImage+Utils.m
//  ZJArmoire
//
//  Created by iBlock on 2017/2/25.
//  Copyright © 2017年 iBlock. All rights reserved.
//

#import "UIImage+Utils.h"
#import <objc/runtime.h>

static NSString *KEY_IMAGE_TAG = @"KEY_IMAGE_TAG";

@implementation UIImage (Utils)

- (void)setImageTag:(NSString *)imageTag {
    objc_setAssociatedObject(self, &KEY_IMAGE_TAG, imageTag, OBJC_ASSOCIATION_COPY);
}

- (NSString *)imageTag {
    return objc_getAssociatedObject(self, &KEY_IMAGE_TAG);
}

@end
