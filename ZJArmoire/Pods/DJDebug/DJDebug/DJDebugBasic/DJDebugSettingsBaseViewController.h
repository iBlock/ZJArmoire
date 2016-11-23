//
//  DJDebugSettingsBaseViewController.h
//  Pods
//
//  Created by iBlock on 16/7/18.
//  Copyright © 2016年 iBlock. All rights reserved.
//

#import "IASKAppSettingsViewController.h"
@protocol DJDebugSettingsBaseFileSettings<NSObject>
//设置bundle的名称
@optional
- (NSString*)bundleName;

@end
@interface DJDebugSettingsBaseViewController : IASKAppSettingsViewController<DJDebugSettingsBaseFileSettings>

- (id)initWithFile:(NSString*)file specifier:(IASKSpecifier*)specifier;

@end
