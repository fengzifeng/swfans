//
//  DrHttpManger.h
//  Driver
//
//  Created by fengzifeng on 16/5/17.
//  Copyright © 2016年 Driver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DrBaseNetworkManager.h"

@interface NSString (DrHttpManager)

- (NSString *)encode;
- (NSString *)decode;
- (id)object;

@end

@interface NSURL (DrHttpManager)
/*!
 @brief 返回URL的接口名称，会去除掉URL中的参数
 */
- (NSString *)interface;

@end

@interface HttpResponse : NSObject

@property (nonatomic, strong) NSURL *request_url;              //请求的链接
@property (nonatomic, strong) NSDictionary *request_params;    //请求的参数
@property (nonatomic, strong) id payload;                      //返回的结果
@property (nonatomic, strong) NSError *error;                  //错误信息
@property (nonatomic, copy) NSString *msg;                     //提示消息

@end

@interface DrHttpManager : NSObject

/**
 @property
 @brief  请求操作的管理器
 */

+ (instancetype)defaultManager;

/*  -------判断当前的网络类型----------
 1、NotReachable     - 没有网络连接
 2、ReachableViaWWAN - 移动网络(2G、3G)
 3、ReachableViaWiFi - WIFI网络
 */
- (AFNetworkReachabilityStatus)networkStatus;

//AFHTTPRequestOperation可以暂停、重新开启、取消 [operation pause]、[operation resume]、[operation cancel];

/** GET 请求 */
- (void)getRequestToUrl:(NSString *)url params:(NSDictionary *)params complete:(void (^)(BOOL successed, HttpResponse *response))complete;

/** POST 请求 */
- (void)postRequestToUrl:(NSString *)url params:(NSDictionary *)params complete:(void (^)(BOOL successed, HttpResponse *response))complete;

/*
 files : 需要上传的文件数组，数组里为多个字典
 字典里的key:
 1、filename: 文件名称（如：demo.jpg）
 2、file: 文件   （支持四种数据类型：NSData、UIImage、NSURL、NSString）NSURL、NSString为文件路径
 3、name : 文件对应字段的name（默认：file）
 4、type: 文件类型（默认：image/jpeg）
 示例： @[@{@"file":_headImg.currentBackgroundImage,@"name":@"head.jpg"}];
 */
- (void)uploadToUrl:(NSString *)url
                                 params:(NSDictionary *)params
                                  files:(NSArray *)files
                               complete:(void (^)(BOOL successed, HttpResponse *response))complete;

//可以查看进度 process_block
- (void)uploadToUrl:(NSString *)url
                                 params:(NSDictionary *)params
                                  files:(NSArray *)files
                                process:(void (^)(long writedBytes, long totalBytes))process
                               complete:(void (^)(BOOL successed, HttpResponse *response))complete;
@end
