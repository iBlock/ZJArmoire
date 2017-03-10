//
//  UIImageView+Utils.m
//  ZJArmoire
//
//  Created by iBlock on 2017/3/2.
//  Copyright © 2017年 iBlock. All rights reserved.
//

#import "UIImageView+Utils.h"

static CGRect oldframe;
static UIImageView *imageView;

@implementation UIImageView (Utils)

- (void)showPreviewImage {
    [self showPreviewImageWithImage:self.image];
}

- (void)showPreviewImageWithImage:(UIImage *)image {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    oldframe = [self convertRect:self.bounds toView:window];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0;
    imageView = [[UIImageView alloc] initWithFrame:oldframe];
    imageView.image = image;
    imageView.tag = 1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer:tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha =1;
    }];
}

- (void)hideImage:(UITapGestureRecognizer*)tap {
    UIView *backgroundView = tap.view;
    UIImageView *imageView = (UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame = oldframe;
        backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}

@end
