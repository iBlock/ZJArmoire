//
//  DJDebug.h
//  Pods
//
//  Created by iBlock on 16/7/25.
//
//

#import <Foundation/Foundation.h>
#import "DJDebugConfig.h"

@protocol DJDebugProtocol <NSObject>

/**
    该方法用于Native页面跳转
    如果跳转的ViewController需要自定义构造函数或者自定义参数，则在该VC中实现以下方法
    例如：
    - (id)DJDebugViewController {
        UIViewController *vc = [[UIViewController alloc] init];
        vc.title = @"自定义标题";
        vc.xxx = xxx;
        vc.backColor = [UIColor redColor];
        return vc;
    }
 */
- (id)DJDebugViewController;

/**
    如需使用自定义webView进行H5页面跳转，可通过以下几个步骤实现：
    1、新建NSObject的 Category 类别，实现下面的DJDebugWebViewController方法
    2、在DJDebugWebViewController方法中返回自定义的 WebView 即可
*/
+ (id)DJDebugWebViewController:(NSString *)customTitle url:(NSString *)url;

/** 当 plist 自定义设置项中的设置发生变更时会回调该方法,
    目前只抛回了 key，可通过该 key 获取最新的值，没有将旧值返回 
 */
+ (void)DJDebugSettingsChangeNotification:(NSString *)key;

/**
    下面方法用于plist自定义设置项中的按钮点击事件回调
    该监听事件方法也可以在 NSObject 的 Category 类别中实现
    通过 key 值可从 NSUserDefault 中取出相应的值
    例如：
    if ([key isEqualToString:@"SYServiceIpRadioGroup"]) {
        NSString *service = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
 */
+ (void)DJDebugButtonClickNotification:(NSString *)key;

/** Debug 模式启动时回调 */
+ (void)DJDebugStartNotification;

/** Debug 模式关闭时回调 */
+ (void)DJDebugStopNotification;

@end

@interface DJDebug : NSObject

/**
 *  Debug 组件初始化，使用默认的 DJDebugConfig 配置
 */
+ (void)initService;

/**
 *  Debug 组件初始化，使用指定的配置文件
 *
 *  @param config 配置信息
 */
+ (void)initWithConfig:(DJDebugConfig *)config;

/**
 *  Debug模式是否在运行
 *
 *  @return 返回 YES 表示组件正在运行
 */
+ (BOOL)isDebugRunning;

@end
