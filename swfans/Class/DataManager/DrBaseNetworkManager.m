//
//  DrBaseNetworkManager.m
//  Driver
//
//  Created by wei on 16/11/8.
//  Copyright © 2016年 Driver. All rights reserved.
//

#import "DrBaseNetworkManager.h"
#import "DrBaseNetworkManager+NetworkTool.h"

@implementation DrBaseNetworkManager
static AFHTTPSessionManager *singleManager = nil;
#pragma mark - 请求

+ (void)setResponseCookiesWithTask:(NSURLSessionDataTask *)task
{
    NSDictionary *fields = [(NSHTTPURLResponse *)task.response allHeaderFields];
    NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:fields forURL:task.currentRequest.URL];
    NSLog(@"cookies = %@",cookies);
    for (NSHTTPCookie *cookie in cookies) {
//        if ([cookie.name isEqualToString:@"jxsessionid"]) {
//            [USERDEFAULTS setObject:cookie.value forKey:@"jxsessionid"];
//            [USERDEFAULTS synchronize];
//        }
//        if ([cookie.name isEqualToString:@"jxverifycode"]) {
//            [USERDEFAULTS setObject:cookie.value forKey:@"jxverifycode"];
//            [USERDEFAULTS synchronize];
//        }
//        if ([cookie.name isEqualToString:@"jxphone"]) {
//            [USERDEFAULTS setObject:cookie.value forKey:@"jxphone"];
//            [USERDEFAULTS synchronize];
//        }
    }
}

+ (void)saveResponseHeaderWithTask:(NSURLSessionDataTask *)task
{
    NSDictionary *fields = [(NSHTTPURLResponse *)task.response allHeaderFields];
    NSLog(@"fields = %@",fields);
//    if ([fields objectForKey:@"jxsessionid"]) {
//        [USERDEFAULTS setObject:[fields objectForKey:@"jxsessionid"] forKey:@"jxsessionid"];
//        [USERDEFAULTS synchronize];
//
//    }
//    if ([fields objectForKey:@"jxverifycode"]) {
//        [USERDEFAULTS setObject:[fields objectForKey:@"jxverifycode"] forKey:@"jxverifycode"];
//        [USERDEFAULTS synchronize];
//    }
//    if ([fields objectForKey:@"jxphone"]) {
//        [USERDEFAULTS setObject:[fields objectForKey:@"jxphone"] forKey:@"jxphone"];
//        [USERDEFAULTS synchronize];
//    }
}

#pragma mark get
+(void)get:(NSString *)url param:(NSDictionary *)para progess:(void (^)(NSProgress *downloadProgress))progess succeed:(void (^)(NSDictionary *result))succeed failed:(void (^)(NSError *error))failed
{
    AFHTTPSessionManager *manager = [DrBaseNetworkManager createManager:url];
    NSLog(@"url:%@,param:%@",url,para);
    [manager GET:url parameters:para progress:progess success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        NSLog(@"currentUrl:%@",task.currentRequest.URL.absoluteString);
//        [DrBaseNetworkManager setResponseCookiesWithTask:task];
        [DrBaseNetworkManager saveResponseHeaderWithTask:task];
        [DrBaseNetworkManager requestSuccuss:task responseObj:responseObject block:succeed];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"currentUrl:%@",task.currentRequest.URL.absoluteString);

        [DrBaseNetworkManager requestFailed:task Error:error block:failed];
    }];
}

#pragma mark 通用post
+(void)post:(NSString *)url param:(NSDictionary *)para progess:(void (^)(NSProgress *downloadProgress))progess succeed:(void (^)(NSDictionary *result))succeed failed:(void (^)(NSError *error))failed
{
    AFHTTPSessionManager *manager = [DrBaseNetworkManager createManager:url];
    [manager POST:url parameters:para progress:progess success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
//        [DrBaseNetworkManager setResponseCookiesWithTask:task];
        [DrBaseNetworkManager saveResponseHeaderWithTask:task];
        [DrBaseNetworkManager requestSuccuss:task responseObj:responseObject block:succeed];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [DrBaseNetworkManager requestFailed:task Error:error block:failed];
    }];
}

#pragma mark 上传数据post
+(void)post:(NSString *)url constructingBody:(void(^)(id<AFMultipartFormData>formData))constructBlock param:(NSDictionary *)para progess:(void (^)(NSProgress *downloadProgress))progess succeed:(void (^)(NSDictionary *result))succeed failed:(void (^)(NSError *error))failed
{
    AFHTTPSessionManager *manager = [DrBaseNetworkManager createManager:url];
    [manager POST:url parameters:para constructingBodyWithBlock:constructBlock progress:progess success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [DrBaseNetworkManager requestSuccuss:task responseObj:responseObject block:succeed];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [DrBaseNetworkManager requestFailed:task Error:error block:failed];
    }];
}

#pragma mark 初始化，设header
+(AFHTTPSessionManager *)createManager:(NSString *)url
{
    if (!singleManager) {
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:@"https://"] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithArray:@[@"text/html",@"text/xml",@"text/plain",@"text/json",@"application/x-javascript",@"application/json",@"image/gif"]]];
        
        singleManager = manager;
        
    }
    [DrBaseNetworkManager setHttpHeader:singleManager];
    [DrBaseNetworkManager setCommonHeader:singleManager url:url];
    NSLog(@"请求头：%@",singleManager.requestSerializer.HTTPRequestHeaders);
    
    return singleManager;
}

#pragma mark 成功处理

+(void)requestSuccuss:(NSURLSessionDataTask *) task responseObj:(id)responseObject block:(void (^)(NSDictionary *result))succeed
{
    NSDictionary *temp = nil;
    
    if (!responseObject || ![responseObject isKindOfClass:[NSDictionary class]])
    {
        temp= [DrBaseNetworkManager defaultErrorResponse];
    }else
    {
        temp = [NSDictionary dictionaryWithDictionary:responseObject];
        
    }
    
    if (succeed) {
        succeed(temp);
    }
}
//容错:防止server返回非法数据
+(NSDictionary *)defaultErrorResponse
{
    return @{
             @"code":@(-47),
             @"msg":@"未知数据",
             @"result":@{}
             };
}

#pragma mark 失败处理
+(void)requestFailed:(NSURLSessionDataTask *) task Error:(NSError *)error block:(void (^)(NSError *error))failed
{   
    NSLog(@"接口请求失败：%@,原因：%@",task.currentRequest.URL,error.localizedDescription);
    if (failed) {
        failed(error);
    }
}

#pragma mark - 检查网络状态
+(void)checkNetStatus:(void(^)(AFNetworkReachabilityStatus status))statusBlock
{
    AFNetworkReachabilityManager *AFNReachManager = [AFNetworkReachabilityManager sharedManager];
    [AFNReachManager stopMonitoring];
    [AFNReachManager setReachabilityStatusChangeBlock:statusBlock];
    [AFNReachManager startMonitoring];
}

+(AFNetworkReachabilityStatus )netStatus
{
    return [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
}

+(BOOL)isReachible
{
    [self checkNetStatus:NULL];
    AFNetworkReachabilityStatus status = [self netStatus];
    if (status == AFNetworkReachabilityStatusUnknown || status == AFNetworkReachabilityStatusNotReachable) {
        return NO;
    }else
    {
        return YES;
    }
}

@end
