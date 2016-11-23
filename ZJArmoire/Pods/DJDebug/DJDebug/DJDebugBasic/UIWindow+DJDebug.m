//
//  UIWindow+DJDebug.m
//  Pods
//
//  Created by iBlock on 16/8/24.
//
//

#import "UIWindow+DJDebug.h"
#import "DJDebugConfig.h"
#import <AudioToolbox/AudioToolbox.h>

static int motionCount;    //摇动次数

extern NSString *DJDebugNotificationMessage;
extern NSString *DebugNotificationMessageType;
extern NSString *DebugNotificationMotionStart;
extern BOOL *DebugKeyMotionIsRunning;
extern DJDebugConfig *DJDebugConfigObj;

@implementation UIWindow (DJDebug)

#if DEBUG

//默认是NO，所以得重写此方法，设成YES
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (DebugKeyMotionIsRunning) {
        return ;
    }
    NSLog(@"结束摇动");
    motionCount++;
    if (motionCount == DJDebugConfigObj.wobbleCount) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//振动效果
        NSLog(@"开启调试模式");
        motionCount = 0;
        [[NSNotificationCenter defaultCenter]
         postNotificationName:DJDebugNotificationMessage object:self userInfo:@{DebugNotificationMessageType:DebugNotificationMotionStart}];
    }
}

#endif

@end
