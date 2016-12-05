//
//  ZJATextField.h
//  ZJArmoire
//
//  Created by iBlock on 2016/12/5.
//  Copyright © 2016年 iBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZJATextFieldDelegate <NSObject>

- (void)ZJATextFieldDeleteBackward:(UITextField *)textField;

@end


@interface ZJATextField : UITextField

@property (nonatomic, weak) id <ZJATextFieldDelegate> zja_delegate;

@end
