//
//  DJDebugConfig.h
//  Pods
//
//  Created by iBlock on 16/7/25.
//
//

#import <Foundation/Foundation.h>

@interface DJDebugConfig : NSObject

/** 自定义配置文件bundle名称 */
@property (nonatomic, strong) NSString *configBundleFileName;
/** 触发Debug模式的晃动次数设置,默认1次 */
@property (nonatomic) int wobbleCount;

@end
