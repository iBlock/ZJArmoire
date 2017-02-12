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

//把指定的颜色给变成透明的，方法如下：
+ (UIImage*) imageToTransparent:(UIImage*) image {
    // 分配内存
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++) {
        if ((*pCurPtr & 0xFFFFFF00) == 0xffffff00) {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // 将内存转成image
    CGDataProviderRef dataProvider =CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight,8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast |kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true,kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // 释放
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}
/** 颜色变化 */
void ProviderReleaseData (void *info, const void *data, size_t size)
{
    free((void*)data);
}

- (void)requetWeather {
    NSString *appcode = @"你自己的AppCode";
    NSString *host = @"http,https://ali-weather.showapi.com";
    NSString *path = @"/area-to-weather";
    NSString *method = @"GET";
    NSString *querys = @"?area=%E4%B8%BD%E6%B1%9F&areaid=101291401&need3HourForcast=\
    0&needAlarm=0&needHourData=0&needIndex=0&needMoreDay=0";
    NSString *url = [NSString stringWithFormat:@"%@%@%@",  host,  path , querys];
    NSString *bodys = @"";
    
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[NSURL URLWithString: url]
                                    cachePolicy:1  timeoutInterval:  5];
    request.HTTPMethod  =  method;
    [request addValue:  [NSString  stringWithFormat:@"APPCODE %@" ,  appcode]
   forHTTPHeaderField:  @"Authorization"];
    NSURLSession *requestSession = [NSURLSession sessionWithConfiguration:
                                    [NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task =
    [requestSession dataTaskWithRequest:request
                      completionHandler:^(NSData * _Nullable body , NSURLResponse * _Nullable response, NSError * _Nullable error) {
                          NSLog(@"Response object: %@" , response);
                          NSString *bodyString = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
                          //打印应答中的body
                          NSLog(@"Response body: %@" , bodyString);
                      }];
    
    [task resume];
}



@end
