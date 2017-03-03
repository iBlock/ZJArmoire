//
//  ZJAWeatherNetwork.m
//  ZJArmoire
//
//  Created by iBlock on 2017/3/2.
//  Copyright © 2017年 iBlock. All rights reserved.
//

#import "ZJAWeatherNetwork.h"

@implementation ZJAWeatherNetwork

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
        NSError *err;
        NSDictionary<NSString *,id> *dic =
        [NSJSONSerialization JSONObjectWithData:body
                                        options:NSJSONReadingMutableContainers
                                          error:&err];
        if(err) {
            NSLog(@"json解析失败：%@",err);
        } else {
            callback(dic);
        }
        
//                                                       NSLog(@"Response object: %@" , response);
//                                                       NSString *bodyString = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
//                                                       
//                                                       //打印应答中的body
//                                                       NSLog(@"Response body: %@" , bodyString);
    }];
    
    [task resume];
}

@end
