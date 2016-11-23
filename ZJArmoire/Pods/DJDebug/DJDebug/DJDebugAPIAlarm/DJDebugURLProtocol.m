//
//  DJDebugURLProtocol.m
//  SuYun
//
//  Created by iBlock on 16/9/1.
//  Copyright © 2016年 58. All rights reserved.
//

#import "DJDebugURLProtocol.h"
#import <objc/runtime.h>
#import "NSObject+DJDebug.h"

//自定义唯一标示符
static NSString *const DJCustomURLProtocolHandledKey = @"DJCustomURLProtocolHandledKey";
static NSString *const kDJDebugAPIResponse = @"kDJDebugAPIResponse";
static NSString *const kDJDebugAPIResponseString = @"kDJDebugAPIResponseString";
static NSString *const kDJDebugAPIRequest = @"kDJDebugAPIRequest";
static NSString *const kDJDebugAPIResponseData = @"kDJDebugAPIResponseData";
static NSString *const kDJDebugAPIError = @"kDJDebugAPIError";
extern NSString *kDJDebugAPISwitchState;

@interface DJDebugProtocolModel()

@property (nonatomic, strong, readwrite) NSMutableDictionary *errorApiList;

- (void)syncUserdefault;

@end

@interface DJDebugURLProtocol ()

@property (nonatomic, strong) NSURLConnection *connection;//网络连接对象
@property (nonatomic, strong) NSMutableDictionary *currentRequestInfo;
@property (nonatomic, strong) NSMutableData *apiData;

- (instancetype)initWithBaseURL:(NSURL *)url
           sessionConfiguration:(NSURLSessionConfiguration *)configuration;

@end

@implementation DJDebugURLProtocol

+ (void)updateURLProtocol {
    BOOL state = [[[NSUserDefaults standardUserDefaults] objectForKey:kDJDebugAPISwitchState] boolValue];
    if (state) {
        [NSURLProtocol registerClass:self];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.protocolClasses = @[NSClassFromString(@"DJDebugURLProtocol")];
        [self swizzedMethodAFNetworking:state];
    } else {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.protocolClasses = nil;
        [NSURLProtocol unregisterClass:self];
    }
}

+ (void)swizzedMethodAFNetworking:(BOOL)state {
    Class afnClass = NSClassFromString(@"AFHTTPSessionManager");
    if (afnClass) {
        SEL originalSelector = @selector(manager);
        SEL swizzledSelector = @selector(DJDebug_manager);
        SEL swizzledSelector2 = @selector(DJDebug_manager_back);
        Method originalMethod = class_getClassMethod(afnClass, originalSelector);
        Method swizzledMethod = class_getClassMethod(self, swizzledSelector);
        Method swizzledMethod2 = class_getClassMethod(self, swizzledSelector2);
        if (state) {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod2);
        }
    }
}

+ (instancetype)DJDebug_manager {
    NSLog(@"DJDebugxxxx");
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.protocolClasses = @[NSClassFromString(@"DJDebugURLProtocol")];
    return [[[self class] alloc] initWithBaseURL:nil sessionConfiguration:configuration];
}

- (instancetype)initWithBaseURL:(NSURL *)url
           sessionConfiguration:(NSURLSessionConfiguration *)configuration {
    return nil;
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    //如果是非http https就不让他通过
    if (![request.URL.scheme isEqualToString:@"http"] && ![request.URL.scheme isEqualToString:@"https"]) {
        return NO;
    }
    
    //看看是否已经处理过了，防止无限循环，如果已经处理过(即设置了允许通过，就不再初始化了)
    if ([NSURLProtocol propertyForKey:DJCustomURLProtocolHandledKey inRequest:request]) {
        return NO;
    }
    
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

- (void)startLoading
{
    //没有缓存 返回这个新的请求
    NSMutableURLRequest *newRequest = [self.request mutableCopy];
    //打标签，防止无限循环
    [NSURLProtocol setProperty:@YES forKey:DJCustomURLProtocolHandledKey inRequest:newRequest];
    self.apiData = nil;
    self.connection = [NSURLConnection connectionWithRequest:newRequest delegate:self];
}

- (void)stopLoading
{
    [self.connection cancel];
    self.connection = nil;
}

#pragma mark - DebugAPILog

- (NSString *)logDebugInfoWithResponse:(NSHTTPURLResponse *)response resposeString:(NSString *)responseString request:(NSURLRequest *)request error:(NSError *)error
{
    BOOL shouldLogError = error ? YES : NO;
    
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n============================================\n=                        DJDebug API Response                        =\n============================================\n\n"];
    
    [logString appendFormat:@"Status:\t%ld\t(%@)\n\n", (long)response.statusCode, [NSHTTPURLResponse localizedStringForStatusCode:response.statusCode]];
    [logString appendFormat:@"Content:\n\t%@\n", responseString];
    [logString appendFormat:@"Respone Header:\n%@\n\n", response.allHeaderFields ? response.allHeaderFields : @"\t\t\t\t\tN/A"];
    if (shouldLogError) {
        [logString appendFormat:@"Error Domain:\t\t\t\t\t\t\t%@\n", error.domain];
        [logString appendFormat:@"Error Domain Code:\t\t\t\t\t\t%ld\n", (long)error.code];
        [logString appendFormat:@"Error Localized Description:\t\t\t%@\n", error.localizedDescription];
        [logString appendFormat:@"Error Localized Failure Reason:\t\t\t%@\n", error.localizedFailureReason];
        [logString appendFormat:@"Error Localized Recovery Suggestion:\t%@\n\n", error.localizedRecoverySuggestion];
    }
    
    [logString appendString:@"\n---------------  Related Request Content  --------------\n"];
    
    [self appendURLRequest:request logStr:logString];
    
    [logString appendFormat:@"\n\n============================================\n=                                Response End                                =\n============================================\n\n\n\n"];
    return logString;
}

- (void)appendURLRequest:(NSURLRequest *)request logStr:(NSMutableString *)logStr
{
    [logStr appendFormat:@"\n\nHTTP URL:\n\t%@", request.URL];
    [logStr appendFormat:@"\n\nHTTP Header:\n%@", request.allHTTPHeaderFields ? request.allHTTPHeaderFields : @"\t\t\t\t\tN/A"];
    [logStr appendFormat:@"\n\nHTTP Body:\n\t%@", [[[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding] DJDebug_defaultValue:@"\t\t\t\tN/A"]];
}

#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    self.currentRequestInfo[kDJDebugAPIResponse] = httpResponse;
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.apiData appendData:data];
    [self.client URLProtocol:self didLoadData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.currentRequestInfo[kDJDebugAPIRequest] = connection.currentRequest;
    NSString *responeStr = [[NSString alloc] initWithData:self.apiData encoding:NSUTF8StringEncoding];
    self.currentRequestInfo[kDJDebugAPIResponseString] = responeStr;
    self.currentRequestInfo[kDJDebugAPIResponseData] = self.apiData;
    [self.client URLProtocolDidFinishLoading:self];
    NSDictionary *responDic;
    if (self.currentRequestInfo[kDJDebugAPIResponseData] != nil) {
        responDic = [NSJSONSerialization JSONObjectWithData:self.currentRequestInfo[kDJDebugAPIResponseData]
                                                    options:NSJSONReadingMutableContainers
                                                      error:NULL];
    }
    if ([responDic isKindOfClass:[NSDictionary class]]) {
        if ([responDic[@"code"] integerValue] != 0) {
            [self apiLog];
        }
    } else if (((NSHTTPURLResponse *)self.currentRequestInfo[kDJDebugAPIResponse]).statusCode != 200) {
        [self apiLog];
    }
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.currentRequestInfo[kDJDebugAPIRequest] = connection.currentRequest;
    self.currentRequestInfo[kDJDebugAPIError] = error;
    [self.client URLProtocol:self didFailWithError:error];
    [self apiLog];
}

- (void)apiLog {
    NSURLRequest *urlRequest = self.currentRequestInfo[kDJDebugAPIRequest];
    NSString *urlPath = urlRequest.URL.path;
    NSMutableArray *apiList = [DJDebugProtocolModel shareInstance].errorApiList[urlPath];
    if (!apiList) {
        apiList = @[].mutableCopy;
        [DJDebugProtocolModel shareInstance].errorApiList[urlPath] = apiList;
    }
    NSString *logStr = [self logDebugInfoWithResponse:self.currentRequestInfo[kDJDebugAPIResponse]
                                        resposeString:self.currentRequestInfo[kDJDebugAPIResponseString]
                                              request:self.currentRequestInfo[kDJDebugAPIRequest]
                                                error:self.currentRequestInfo[kDJDebugAPIError]];
    [apiList addObject:@{@"path":urlPath,@"log":logStr,@"time":[self getCurrentTime]}];
    [[DJDebugProtocolModel shareInstance] syncUserdefault];
}

- (NSString *)getCurrentTime {
    NSDateFormatter*formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyy-MM-dd HH:mm:ss"];
    NSString*dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

- (NSMutableDictionary *)currentRequestInfo {
    if (!_currentRequestInfo) {
        _currentRequestInfo = @{}.mutableCopy;
    }
    return _currentRequestInfo;
}

- (NSMutableData *)apiData {
    if (!_apiData) {
        _apiData = [[NSMutableData alloc] init];
    }
    return _apiData;
}

@end

@implementation DJDebugProtocolModel

+ (DJDebugProtocolModel *)shareInstance {
    static dispatch_once_t onceToken;
    static DJDebugProtocolModel *shareInstance;
    dispatch_once(&onceToken, ^{
        if (!shareInstance) {
            shareInstance = [[DJDebugProtocolModel alloc] init];
        }
    });
    return shareInstance;
}

- (void)syncUserdefault {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.errorApiList];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"DJDebugProtocolModel"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Setter and Getter

- (NSMutableDictionary *)errorApiList {
    if (!_errorApiList) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"DJDebugProtocolModel"];
        NSMutableDictionary *lastData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (lastData) {
            _errorApiList = lastData;
        } else {
            _errorApiList = @{}.mutableCopy;
        }
    }
    return _errorApiList;
}

@end