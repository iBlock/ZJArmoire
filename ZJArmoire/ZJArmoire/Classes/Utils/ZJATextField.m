//
//  ZJATextField.m
//  ZJArmoire
//
//  Created by iBlock on 2016/12/5.
//  Copyright © 2016年 iBlock. All rights reserved.
//

#import "ZJATextField.h"

@implementation ZJATextField

- (void)deleteBackward {
    [super deleteBackward];
    
    if ([self.zja_delegate respondsToSelector:@selector(ZJATextFieldDeleteBackward:)]) {
        [self.zja_delegate ZJATextFieldDeleteBackward:self];
    }
}

@end
