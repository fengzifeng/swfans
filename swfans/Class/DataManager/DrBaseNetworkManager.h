//
//  DrBaseNetworkManager.h
//  Driver
//
//  Created by wei on 16/11/8.
//  Copyright © 2016年 Driver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface DrBaseNetworkManager : NSObject

/**
 * 网络可达
 */
+(BOOL)isReachible;
/**
 * 返回当前网络状态
 */
+(AFNetworkReachabilityStatus )netStatus;
/**
 * 监控网络状态
 */
+(void)checkNetStatus:(void(^)(AFNetworkReachabilityStatus status))statusBlock;

/**
 * get
 * 不需要进度传NULL
 */
+(void)get:(NSString *)url param:(NSDictionary *)param progess:(void (^)(NSProgress *downloadProgress))progess succeed:(void (^)(NSDictionary *result))succeed failed:(void (^)(NSError *error))failed;

/**
 * post
 * 不需要进度传NULL
 */
+(void)post:(NSString *)url param:(NSDictionary *)param progess:(void (^)(NSProgress *downloadProgress))progess succeed:(void (^)(NSDictionary *result))succeed failed:(void (^)(NSError *error))failed;

/**
 * post 上传数据
 * 不需要进度传NULL
 */
+(void)post:(NSString *)url constructingBody:(void(^)(id<AFMultipartFormData>formData))constructBlock param:(NSDictionary *)para progess:(void (^)(NSProgress *downloadProgress))progess succeed:(void (^)(NSDictionary *result))succeed failed:(void (^)(NSError *error))failed;
@end
