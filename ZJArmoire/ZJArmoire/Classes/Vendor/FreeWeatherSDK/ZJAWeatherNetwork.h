//
//  ZJAWeatherNetwork.h
//  ZJArmoire
//
//  Created by iBlock on 2017/3/2.
//  Copyright © 2017年 iBlock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJAWeatherNetwork : NSObject

+ (void)requestWeather:(void(^)(NSDictionary<NSString *,id> *result))callback;

@end
