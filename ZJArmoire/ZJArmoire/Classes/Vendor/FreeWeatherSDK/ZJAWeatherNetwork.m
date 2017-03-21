//
//  ZJAWeatherNetwork.m
//  ZJArmoire
//
//  Created by iBlock on 2017/3/2.
//  Copyright © 2017年 iBlock. All rights reserved.
//

#import "ZJAWeatherNetwork.h"
#import "AppInclude.h"

NSString *kWeatherDic = @"KEY_WEATHER_DIC";
NSString *kLastCacheTime = @"KEY_CACHE_WEATHER_TIME";

@implementation ZJAWeatherNetwork

+ (void)requestWeather:(void (^)(NSDictionary<NSString *,id> *))callback {
    HttpUtil *httpUtil = [HttpUtil instance];
    NSString *path = @"/area-to-weather";
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDate *lastTime = [userDefault objectForKey:kLastCacheTime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *lastDateStr = [formatter stringFromDate:lastTime];
    NSString *nowDateStr = [formatter stringFromDate:[NSDate date]];
    if ([nowDateStr isEqualToString:lastDateStr]) {
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:lastTime];
        if (timeInterval <= 60 * 60 * 2) {
            NSDictionary *weatherDic = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefault objectForKey:kWeatherDic]];
            if (weatherDic) {
                callback(weatherDic);
                return;
            }
        }
    }
    
    [httpUtil httpGet:path pathParams:nil queryParams:@{@"areaid":@"101010100",@"needMoreDay":@"1"} headerParams:nil completionBlock:^(NSData * _Nullable body , NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *bodyString = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
        NSLog(@"Response body: %@" , bodyString);
        if (body) {
            NSError *err;
            NSDictionary<NSString *,id> *dic =
            [NSJSONSerialization JSONObjectWithData:body
                                            options:NSJSONReadingMutableContainers
                                              error:&err];
            if(err) {
                NSLog(@"json解析失败：%@",err);
            }
            if ([dic[@"showapi_res_code"] integerValue] == 0) {
                NSDictionary *weatherDic = dic[@"showapi_res_body"];
                NSData *archiverData = [NSKeyedArchiver archivedDataWithRootObject:weatherDic];
                [userDefault setObject:archiverData forKey:kWeatherDic];
                [userDefault setObject:[NSDate date] forKey:kLastCacheTime];
                callback(weatherDic);
                
            } else {
                NSLog(@"请求失败了，error = %@", dic[@"showapi_res_error"]);
                callback(@{});
            }
        } else {
            callback(@{});
        }
    }];
}

/*
+ (void)requestWeather:(void (^)(NSDictionary<NSString *,id> *))callback {
    NSString *appcode = @"15364f47413c4a87b9d02375b6ccef8d";
    NSString *host = @"http://saweather.market.alicloudapi.com";
    NSString *path = @"/area-to-weather";
    NSString *method = @"GET";
    NSString *querys = @"?areaid=101010100";
    NSString *url = [NSString stringWithFormat:@"%@%@%@",  host,  path , querys];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: url]  cachePolicy:1  timeoutInterval:  5];
    request.HTTPMethod  =  method;
    [request addValue:  [NSString  stringWithFormat:@"APPCODE %@" ,  appcode]  forHTTPHeaderField:  @"Authorization"];
    NSURLSession *requestSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [requestSession dataTaskWithRequest:request
                                                   completionHandler:^(NSData * _Nullable body , NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        NSString *bodyString = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
        NSLog(@"Response body: %@" , bodyString);
        if (body) {
            NSError *err;
            NSDictionary<NSString *,id> *dic =
            [NSJSONSerialization JSONObjectWithData:body
                                            options:NSJSONReadingMutableContainers
                                              error:&err];
            if(err) {
                NSLog(@"json解析失败：%@",err);
            }
            if ([dic[@"status"] integerValue] == 0) {
                callback(dic[@"result"]);
            } else {
                callback(@{});
            }
        } else {
            callback(@{});
        }
    }];
    
    [task resume];
}
 */
/*
+ (void)requestWeather:(void (^)(NSDictionary<NSString *,id> *))callback {
    NSString *appcode = @"15364f47413c4a87b9d02375b6ccef8d";
    NSString *host = @"http://jisutqybmf.market.alicloudapi.com";
    NSString *path = @"/weather/query";
    NSString *method = @"GET";
    NSString *querys = @"?cityid=1";
    NSString *url = [NSString stringWithFormat:@"%@%@%@",  host,  path , querys];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: url]  cachePolicy:1  timeoutInterval: 15];
    request.HTTPMethod  =  method;
    [request addValue:  [NSString  stringWithFormat:@"APPCODE %@" ,  appcode]  forHTTPHeaderField:  @"Authorization"];
    NSURLSession *requestSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [requestSession dataTaskWithRequest:request
                                                   completionHandler:^(NSData * _Nullable body , NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        NSString *bodyString = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
        NSLog(@"Response body: %@" , bodyString);
        if (body) {
            NSError *err;
            NSDictionary<NSString *,id> *dic =
            [NSJSONSerialization JSONObjectWithData:body
                                            options:NSJSONReadingMutableContainers
                                              error:&err];
            if(err) {
                NSLog(@"json解析失败：%@",err);
            }
            if ([dic[@"status"] integerValue] == 0) {
                callback(dic[@"result"]);
            } else {
                callback(@{});
            }
        } else {
            callback(@{});
        }
    }];
    
    [task resume];
}*/

@end
