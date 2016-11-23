//
//  DJDebug.m
//  Pods
//
//  Created by iBlock on 16/7/25.
//
//

#import "DJDebug.h"
#import "FLEXManager.h"
#import "DJDebugWindow.h"
#import "DJDebugURLProtocol.h"
#import "DJDebugSettingsBaseViewController.h"
#import "IASKAppSettingsViewController.h"

NSString *const DJDebugNotificationMessage = @"DJDebugNotificationMessage";
NSString *const DebugNotificationMessageType = @"DebugNotificationMessageType";
NSString *const DebugNotificationMotionStart = @"DebugNotificationMotionStart";
NSString *const DebugNotificationMotionStop = @"DebugNotificationMotionStop";
NSString *const DebugNotificationCloseConfigWindow = @"DebugNotificationCloseConfigWindow";

DJDebugConfig const *DJDebugConfigObj;
BOOL const *DebugKeyMotionIsRunning = NO;

NSString *const DebugIsRunningFlagKey = @"DebugIsRunningFlagKey";

extern NSString *kDJDebugAPISwitchState;

@interface DJDebug()<DJDebugProtocol>

@property (nonatomic, strong)DJDebugWindow *debugWindow;
@property (nonatomic, strong)UIWindow *configWindow;
@property (nonatomic, strong)DJDebugSettingsBaseViewController *configViewController;

@end

@implementation DJDebug

#pragma mark - PublicMethod

+ (BOOL)isDebugRunning {
    return DebugKeyMotionIsRunning;
}

+ (void)initService {
    [DJDebug initWithConfig:[[DJDebugConfig alloc] init]];
}

+ (void)initWithConfig:(DJDebugConfig *)config {
    DJDebug *debug = [DJDebug shareInstance];
    DJDebugConfigObj = config;
    
    BOOL isRunning = [[NSUserDefaults standardUserDefaults] boolForKey:DebugIsRunningFlagKey];
    if (!DebugKeyMotionIsRunning && isRunning) {
        DebugKeyMotionIsRunning = isRunning;
        NSNotification *notification = [NSNotification notificationWithName:DJDebugNotificationMessage object:nil userInfo:@{DebugNotificationMessageType:DebugNotificationMotionStart}];
        if([NSThread isMainThread]){
            [[DJDebug shareInstance] notificationEvent:notification];

        }else{
            dispatch_sync(dispatch_get_main_queue(), ^{
            [[DJDebug shareInstance] notificationEvent:notification];
            });
        }
    }
}

+ (id)shareInstance {
    static DJDebug *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DJDebug alloc] init];
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        [defaultCenter addObserver:instance selector:@selector(notificationEvent:) name:DJDebugNotificationMessage object:nil];
    });
    
    return instance;
}

#pragma mark - Event and Respone

- (void)startDebugModel {
    DebugKeyMotionIsRunning = YES;
    DJDebug *debug = [DJDebug shareInstance];
    [debug.debugWindow makeKeyAndVisible];
    [[UIApplication sharedApplication].windows[0] makeKeyAndVisible];
    debug.debugWindow.hidden = NO;
    
    if ([DJDebug respondsToSelector:@selector(DJDebugStartNotification)]) {
        [DJDebug DJDebugStartNotification];
    }
    [DJDebugURLProtocol updateURLProtocol];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:DebugIsRunningFlagKey];
}

- (void)stopDebugModel {
    DebugKeyMotionIsRunning = NO;
    DJDebug *debug = [DJDebug shareInstance];
    [debug.debugWindow resignKeyWindow];
    debug.debugWindow.hidden = YES;
    [self onClickDoneButtonItem];
    
    if ([DJDebug respondsToSelector:@selector(DJDebugStopNotification)]) {
        [DJDebug DJDebugStopNotification];
    }
    [DJDebugURLProtocol updateURLProtocol];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:DebugIsRunningFlagKey];
}

- (void)pushDebugConfigViewController {
    __block CGRect configWindowFrame = self.configWindow.frame;
    configWindowFrame.origin.y = configWindowFrame.size.height;
    self.configWindow.frame = configWindowFrame;
    [self.configWindow makeKeyAndVisible];
    [UIView animateWithDuration:0.3 animations:^{
        configWindowFrame.origin.y = 0;
        self.configWindow.frame = configWindowFrame;
    }];
}
 
- (void)onClickDoneButtonItem {
    [self.configWindow resignKeyWindow];
    self.configWindow.hidden = YES;
    [[UIApplication sharedApplication].windows[0] makeKeyAndVisible];
    self.configWindow = nil;
}

#pragma mark - NSNotification

- (void)notificationEvent:(NSNotification *)notification {
    NSString *messageType = [notification userInfo][DebugNotificationMessageType];
    if ([messageType isEqualToString:DebugNotificationMotionStart]) {
        [self startDebugModel];
    } else if ([messageType isEqualToString:DebugNotificationMotionStop]) {
        [self stopDebugModel];
    } else if ([messageType isEqualToString:DebugNotificationCloseConfigWindow]) {
        [self onClickDoneButtonItem];
    }
}

#pragma mark - Setter and Getter

- (DJDebugWindow *)debugWindow {
    if (!_debugWindow) {
        CGRect frame = [UIScreen mainScreen].bounds;
        _debugWindow = [[DJDebugWindow alloc]
                        initWithFrame:CGRectMake(frame.size.width-100,
                                                 frame.size.height-120, 60, 60)];
        [_debugWindow.debugButton addTarget:self action:@selector(pushDebugConfigViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _debugWindow;
}

- (UIWindow *)configWindow {
    if (!_configWindow) {
        _configWindow = [[UIWindow alloc] init];
        _configWindow.windowLevel = UIWindowLevelAlert + 1.0f;
        _configWindow.frame = [UIScreen mainScreen].bounds;
        _configWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:self.configViewController];
    }
    return _configWindow;
}

- (DJDebugSettingsBaseViewController *)configViewController {
    if (!_configViewController) {
        _configViewController = [[DJDebugSettingsBaseViewController alloc] initWithFile:@"DJDebug" specifier:[[IASKSpecifier alloc] initWithSpecifier:@{@"Key":@"配置项"}]];
        _configViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onClickDoneButtonItem)];
    }
    return _configViewController;
}

@end
