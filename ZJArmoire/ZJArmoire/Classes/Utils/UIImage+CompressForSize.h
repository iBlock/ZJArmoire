//
//  UIImage+CompressForSize.h
//  ZJArmoire
//
//  Created by iBlock on 2016/12/14.
//  Copyright © 2016年 iBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CompressForSize)

- (UIImage *)compressImage;
+ (UIImage*) imageToTransparent:(UIImage*) image;

@end
