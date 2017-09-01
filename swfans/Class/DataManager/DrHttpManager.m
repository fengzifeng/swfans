//
//  DrHttpManger.m
//  Driver
//
//  Created by fengzifeng on 16/5/17.
//  Copyright © 2016年 Driver. All rights reserved.
//

#import "DrHttpManager.h"

#define TLog(...) NSLog(@"%@",[NSString stringWithFormat:__VA_ARGS__])

@implementation NSString (DrHttpManager)

- (NSString *)encode
{
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                              (CFStringRef)self,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&amp;=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    outputStr = [outputStr stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    return outputStr;
}

- (NSString *)decode
{
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
                                                                              kCFAllocatorDefault,
                                                                              (__bridge CFStringRef)self,
                                                                              CFSTR(""),
                                                                              kCFStringEncodingUTF8));
    return outputStr;
}

- (id)object
{
    id object = nil;
    @try {
        NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
        object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"%s [Line %d] JSON字符串转换成对象出错了-->\n%@",__PRETTY_FUNCTION__, __LINE__,exception);
    }
    @finally {
    }
    
    return object;
}

@end

@implementation NSURL (DrHttpManager)

- (NSString *)interface
{
    if(self.port){
        return [NSString stringWithFormat:@"%@://%@:%@%@",self.scheme,self.host,self.port,self.path];
    }
    return [NSString stringWithFormat:@"%@://%@%@",self.scheme,self.host,self.path];
}

@end

@implementation HttpResponse

@end

@implementation DrHttpManager

- (id)init
{
    self = [super init];
    if (self) {
        
        [DrBaseNetworkManager checkNetStatus:^(AFNetworkReachabilityStatus status) {
            NSLog(@"AFNetworkReachabilityStatus: %@", AFStringFromNetworkReachabilityStatus(status));
        }];
    }
    
    return self;
}

+ (instancetype)defaultManager
{
    static dispatch_once_t pred = 0;
    __strong static id defaultHttpManager = nil;
    dispatch_once( &pred, ^{
        defaultHttpManager = [[self alloc] init];
    });
    
    return defaultHttpManager;
}

- (AFNetworkReachabilityStatus)networkStatus
{
    return [DrBaseNetworkManager netStatus];//[_operationManager.reachabilityManager networkReachabilityStatus];
}

- (void)getRequestToUrl:(NSString *)url params:(NSDictionary *)params complete:(void (^)(BOOL successed, HttpResponse *))complete
{
    [self requestToUrl:url method:@"GET" params:params complete:complete];
}

- (void)postRequestToUrl:(NSString *)url params:(NSDictionary *)params complete:(void (^)(BOOL successed, HttpResponse *response))complete
{
    [self requestToUrl:url method:@"POST" params:params complete:complete];
}

- (void)uploadToUrl:(NSString *)url
                                 params:(NSDictionary *)params
                                  files:(NSArray *)files
                               complete:(void (^)(BOOL successed, HttpResponse *response))complete
{
    return [self uploadToUrl:url params:params files:files process:nil complete:complete];
}

- (void)requestToUrl:(NSString *)url method:(NSString *)method
                                  params:(NSDictionary *)params complete:(void (^)(BOOL successed, HttpResponse *))complete
{
    //NSMutableURLRequest *request = [self requestWithUrl:url method:method params:params];
    if ([method isEqualToString:@"POST"]) {
        [DrBaseNetworkManager post:url param:params progess:NULL succeed:^(NSDictionary *result) {
            
            HttpResponse *resObj = [[HttpResponse alloc] init];
            resObj.request_url = [NSURL URLWithString:url];
            resObj.request_params = params;
            resObj.payload = result;
            resObj.error = nil;//operation.error;
            if (result && [result isKindOfClass:[NSDictionary class]]){
                resObj.msg = [result valueForKey:@"msg"];
            }
            
            if ([resObj.payload[@"code"] intValue] == 0) {
                complete ? complete(YES, resObj) : nil;
            } else {
                complete ? complete(NO, resObj) : nil;
            }

        } failed:^(NSError *error) {
            HttpResponse *resObj = [[HttpResponse alloc] init];
            resObj.request_url = [NSURL URLWithString:url];//operation.request.URL;
            resObj.request_params = params;
            resObj.error = error;
            complete ? complete(NO,resObj) : nil;
        }];
    }else
    {
        [DrBaseNetworkManager get:url param:params progess:NULL succeed:^(NSDictionary *result) {
            
            HttpResponse *resObj = [[HttpResponse alloc] init];
            resObj.request_url = [NSURL URLWithString:url];
            resObj.request_params = params;
            resObj.payload = result;
            resObj.error = nil;//operation.error;
            if (result && [result isKindOfClass:[NSDictionary class]]){
                resObj.msg = [result valueForKey:@"msg"];
            }
            NSLog(@"resObj:%@",resObj.payload);
            complete ? complete(YES, resObj) : nil;

//            if ([resObj.payload[@"code"] intValue] == 0) {
//                complete ? complete(YES, resObj) : nil;
//            } else {
//                complete ? complete(NO, resObj) : nil;
//            }
            
        } failed:^(NSError *error) {

            HttpResponse *resObj = [[HttpResponse alloc] init];
            resObj.request_url = [NSURL URLWithString:url];//operation.request.URL;
            resObj.request_params = params;
            resObj.error = error;
            NSLog(@"resObj:%@",resObj.error);

            complete ? complete(NO,resObj) : nil;

        }];
    }
    
    
}

- (void)dictionaryWithData:(id)data complete:(void (^)(NSDictionary *object))complete
{
    __block NSDictionary *object = data;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if ([data isKindOfClass:[NSData class]]) {
            object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        }
        if ([data isKindOfClass:[NSString class]]) {
            object = [data object];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            complete ? complete(object?:data) : nil;
        });
    });
}

- (NSMutableURLRequest *)requestWithUrl:(NSString *)url method:(NSString *)method params:(NSDictionary *)params
{
    NSMutableDictionary *requestParams = [params mutableCopy];
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    [[self class] setHttpHeader:serializer];

    NSMutableURLRequest *request = [serializer requestWithMethod:method URLString:url parameters:requestParams error:nil];
    request.accessibilityHint = [@([[NSDate date] timeIntervalSince1970]) stringValue];
    
    [request setTimeoutInterval:20];

//    [self setCookieForRequest:request];
    
    return request;
}

+ (void)setHttpHeader:(AFHTTPRequestSerializer *)manager{
    
    //    时间戳
//    NSString *time = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
//    [manager setValue:DRUserManagerShare.cityCode                             forHTTPHeaderField:@"cityid"];
//    [manager setValue:time                                                    forHTTPHeaderField:@"time"];
//    [manager setValue:@"ios"                                                  forHTTPHeaderField:@"os"];
//    [manager setValue:@"jkqad"                                                forHTTPHeaderField:@"type"];
//    [manager setValue:[UIDevice dr_deviceID]                                  forHTTPHeaderField:@"imei"];
//    [manager setValue:[UIDevice dr_IDFA]                                      forHTTPHeaderField:@"idfa"];
//    [manager setValue:[UIDevice dr_OSVer]                                     forHTTPHeaderField:@"osv"];
//    [manager setValue:[UIDevice dr_devicemodel]                               forHTTPHeaderField:@"model"];
//    [manager setValue:@"640"                                                  forHTTPHeaderField:@"adwidth"];
//    [manager setValue:@"960"                                                  forHTTPHeaderField:@"adheight"];
//    [manager setValue:DR_CHANNEL_ID                                           forHTTPHeaderField:@"channelid"];
//    [manager setValue:DR_Product_ID                                           forHTTPHeaderField:@"productid"];
//    [manager setValue:[DrPrefs appVersion]                                    forHTTPHeaderField:@"version"];
//    [manager setValue:[NSString stringWithFormat:@"%ld",(long)[[NSNumber numberWithFloat:kMAIN_SCREEN_HEIGHT] integerValue]]   forHTTPHeaderField:@"screenheight"];
//    [manager setValue:[NSString stringWithFormat:@"%ld",(long)[[NSNumber numberWithFloat:kMAIN_SCREEN_WIDTH] integerValue]]    forHTTPHeaderField:@"screenwidth"];
    
}


//在HTTPHeaderField里返回cookies
- (void)setCookieForRequest:(NSMutableURLRequest *)request
{
    NSArray* availableCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:availableCookies];
    [request setAllHTTPHeaderFields:headers];
}


//打印每个接口的响应时间
- (void)takesTimeWithRequest:(NSURLRequest *)request flag:(NSString *)flag
{
    if (request && request.accessibilityHint) {
        NSURL *url = request.URL;
        
        double beginTime = [request.accessibilityHint doubleValue];
        double localTime = [[NSDate date] timeIntervalSince1970];
        
        TLog(@"%@: %@    耗时：%.3f秒",flag,url.interface,localTime-beginTime);
    }
}

- (void)uploadToUrl:(NSString *)url
                                 params:(NSDictionary *)params
                                  files:(NSArray *)files
                                process:(void (^)(long writedBytes, long totalBytes))process
                               complete:(void (^)(BOOL successed, HttpResponse *response))complete
{
    TLog(@"post request url:  %@  \npost params:  %@",url,params);
    
    [DrBaseNetworkManager post:url constructingBody:^(id<AFMultipartFormData> formData) {
        for (NSDictionary *fileItem in files) {
            id value = [fileItem objectForKey:@"file"];        //支持四种数据类型：NSData、UIImage、NSURL、NSString
            NSString *name = [fileItem objectForKey:@"name"]?:@"file";            //文件字段的name
            NSString *fileName = [fileItem objectForKey:@"filename"]?:@"";       //文件名称
            NSString *mimeType = [fileItem objectForKey:@"type"]?:@"image/jpeg";       //文件类型
            
            if ([value isKindOfClass:[NSData class]]) {
                [formData appendPartWithFileData:value name:name fileName:fileName mimeType:mimeType];
            }else if ([value isKindOfClass:[UIImage class]]) {
                //转换为JPEG图片并把质量下降0.5
                NSData *data = UIImageJPEGRepresentation(value, 0.5);
                [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
            }else if ([value isKindOfClass:[NSURL class]]) {
                [formData appendPartWithFileURL:value name:name fileName:fileName mimeType:mimeType error:nil];
            }else if ([value isKindOfClass:[NSString class]]) {
                [formData appendPartWithFileURL:[NSURL URLWithString:value]  name:name fileName:fileName mimeType:mimeType error:nil];
            }
        }

    } param:params progess:^(NSProgress *downloadProgress){
        float progress = (float)downloadProgress.completedUnitCount / (float)downloadProgress.totalUnitCount;//(float)totalBytesWritten / totalBytesExpectedToWrite;
        NSLog(@"upload process: %.0f%%",progress);
        if (process) {
            process(downloadProgress.completedUnitCount,downloadProgress.totalUnitCount);
        }
    }succeed:^(NSDictionary *result) {
        if (complete) {
            HttpResponse *resObj = [[HttpResponse alloc] init];
            resObj.request_url = [NSURL URLWithString:url];//operation.request.URL;
            resObj.request_params = params;
            resObj.payload = result;//object;
            if (result && [result isKindOfClass:[NSDictionary class]]){
                resObj.msg = result[@"msg"];
            }
            
            if ([resObj.payload[@"code"] intValue] == 0) {
                complete ? complete(YES, resObj) : nil;
            } else {
                complete ? complete(NO, resObj) : nil;
            }
        }
    } failed:^(NSError *error) {
        if (complete) {
            HttpResponse *resObj = [[HttpResponse alloc] init];
            resObj.request_url = [NSURL URLWithString:url];//operation.request.URL;
            resObj.request_params = params;
            resObj.error = error;
            
            complete ? complete(NO,resObj) : nil;
        }
    }];
}

@end
