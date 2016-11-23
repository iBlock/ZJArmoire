//
//  UINavigationController+DJDebug.m
//  Pods
//
//  Created by iBlock on 16/9/7.
//
//

#ifdef DEBUG

#import "UINavigationController+DJDebug.h"
#import <objc/runtime.h>
#import "NSObject+DJDebug.h"

extern NSString *const kDJDebugPageJumpRecord;
extern NSString *const kDJDebugPageJumpMark;
extern NSString *const kDJDebugPageTitle;
extern NSString *const kDJDebugJumpRecordInfoSwitchState;

NSMutableDictionary *DJDebugJumpPageInfoDic;

@implementation UINavigationController (DJDebug)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        id switchState = [[NSUserDefaults standardUserDefaults] objectForKey:kDJDebugJumpRecordInfoSwitchState];
        BOOL flag = NO;
        if (switchState) {
            flag = [switchState boolValue];
        } else {
            flag = NO;
            [[NSUserDefaults standardUserDefaults] setObject:@(flag) forKey:kDJDebugJumpRecordInfoSwitchState];
        }
        
        if (flag) {
            Class vcClass = [self class];
            SEL originalSelector = @selector(pushViewController:animated:);
            SEL swizzledSelector = @selector(DJDebug_pushViewController:animated:);
            Method originalMethod = class_getInstanceMethod(vcClass, originalSelector);
            Method swizzledMethod = class_getInstanceMethod(vcClass, swizzledSelector);
            method_exchangeImplementations(originalMethod, swizzledMethod);
            NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kDJDebugPageJumpRecord];
            DJDebugJumpPageInfoDic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            if (!DJDebugJumpPageInfoDic) {
                DJDebugJumpPageInfoDic = @{}.mutableCopy;
            }
        }
    });
}

- (void)DJDebug_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self DJDebug_pushViewController:viewController animated:animated];
        if (![viewController.title isEqualToString:kDJDebugPageJumpMark] &&
            ![NSStringFromClass([viewController class]) hasPrefix:@"DJDebug"]) {
            NSMutableDictionary *dic = [UINavigationController DJDebug_dictionaryOfModel:viewController].mutableCopy;
            dic[kDJDebugPageTitle] = viewController.title?:@"没有标题";
            DJDebugJumpPageInfoDic[NSStringFromClass([viewController class])] = dic;
            [self DJDebugJumpPageInfoStore:dic vc:viewController];
        }
}

- (void)DJDebugJumpPageInfoStore:(NSMutableDictionary *)currentPageInfo vc:(UIViewController *)viewController {
    @synchronized (self) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            currentPageInfo[kDJDebugPageTitle] = viewController.title?:@"没有标题";
            DJDebugJumpPageInfoDic[NSStringFromClass([viewController class])] = currentPageInfo;
            NSData *jumpRecordData = [NSKeyedArchiver archivedDataWithRootObject:DJDebugJumpPageInfoDic];
            [[NSUserDefaults standardUserDefaults] setObject:jumpRecordData forKey:kDJDebugPageJumpRecord];
        });
    }
}

@end

#endif
