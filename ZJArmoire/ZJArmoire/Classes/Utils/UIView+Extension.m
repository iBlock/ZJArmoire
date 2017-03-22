//
//  UIView+Extension.m
//  ZJArmoire
//
//  Created by iBlock on 2017/3/21.
//  Copyright © 2017年 iBlock. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (UIViewController *)currentviewController
{
    UIResponder *responder = self;
    while ((responder = [responder nextResponder])){
        if ([responder isKindOfClass: [UIViewController class]]){
            return (UIViewController *)responder;
        }
    }
    return nil;
}

@end
