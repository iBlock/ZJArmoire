//
//  UIImage+CompressForSize.m
//  ZJArmoire
//
//  Created by iBlock on 2016/12/14.
//  Copyright © 2016年 iBlock. All rights reserved.
//

#import "UIImage+CompressForSize.h"
#define KitTargetPx 1280

@implementation UIImage (CompressForSize)

- (UIImage *)compressImage {
    UIImage *newImage = nil;  // 尺寸压缩后的新图片
    CGSize imageSize = self.size; // 源图片的size
    CGFloat width = imageSize.width; // 源图片的宽
    CGFloat height = imageSize.height; // 原图片的高
    BOOL drawImge = NO;   // 是否需要重绘图片 默认是NO
    CGFloat scaleFactor = 0.0;  // 压缩比例
    CGFloat scaledWidth = KitTargetPx;  // 压缩时的宽度 默认是参照像素
    CGFloat scaledHeight = KitTargetPx; // 压缩是的高度 默认是参照像素
    // 先进行图片的尺寸的判断
    // a.图片宽高均≤参照像素时，图片尺寸保持不变
    if (width < KitTargetPx && height < KitTargetPx) {
        newImage = self;
    }
    // b.宽或高均＞1280px时
    else if (width > KitTargetPx && height > KitTargetPx) {
        drawImge = YES;
        CGFloat factor = width / height;
        if (factor <= 2) {
            // b.1图片宽高比≤2，则将图片宽或者高取大的等比压缩至1280px
            if (width > height) {
                scaleFactor  = KitTargetPx / width;
            } else {
                scaleFactor = KitTargetPx / height;
            }
        } else {
            // b.2图片宽高比＞2时，则宽或者高取小的等比压缩至1280px
            if (width > height) {
                scaleFactor  = KitTargetPx / height;
            } else {
                scaleFactor = KitTargetPx / width;
            }
        }
    }
    // c.宽高一个＞1280px，另一个＜1280px 宽大于1280
    else if (width > KitTargetPx &&  height < KitTargetPx ) {
        if (width / height > 2) {
            newImage = self;
        } else {
            drawImge = YES;
            scaleFactor = KitTargetPx / width;
        }
    }
    // c.宽高一个＞1280px，另一个＜1280px 高大于1280
    else if (width < KitTargetPx &&  height > KitTargetPx) {
        if (height / width > 2) {
            newImage = self;
        } else {
            drawImge = YES;
            scaleFactor = KitTargetPx / height;
        }
    }
    // 如果图片需要重绘 就按照新的宽高压缩重绘图片
    if (drawImge == YES) {
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        UIGraphicsBeginImageContext(CGSizeMake(scaledWidth, scaledHeight));
        // 绘制改变大小的图片
        [self drawInRect:CGRectMake(0, 0, scaledWidth,scaledHeight)];
        // 从当前context中创建一个改变大小后的图片
        newImage =UIGraphicsGetImageFromCurrentImageContext();
        // 使当前的context出堆栈
        UIGraphicsEndImageContext();
    }
    // 防止出错  可以删掉的
    if (newImage == nil) {
        newImage = self;
    }
    // 如果图片大小大于200kb 在进行质量上压缩
    NSData * scaledImageData = nil;
    if (UIImageJPEGRepresentation(newImage, 1) == nil) {
        scaledImageData = UIImagePNGRepresentation(newImage);
    }else{
        scaledImageData = UIImageJPEGRepresentation(newImage, 1);
        if (scaledImageData.length >= 1024 * 200) {
            scaledImageData = UIImageJPEGRepresentation(newImage, 0.9);
        }
    }

    UIImage *scaledImage = [UIImage imageWithData:scaledImageData];
    return scaledImage;
}

@end
