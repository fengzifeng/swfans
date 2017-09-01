//
//  DrBaseNetworkManager+NetworkTool.h
//  Driver
//
//  Created by wei on 16/11/9.
//  Copyright © 2016年 Driver. All rights reserved.
//

#import "DrBaseNetworkManager.h"

@interface DrBaseNetworkManager (NetworkTool)

/**
 * 为request添加请求header
 */
+ (NSMutableURLRequest *)requestEncryption:(NSMutableURLRequest *)request;

/**
 * 为NSMutableURLRequest 或 AFHTTPSessionManager添加请求头,urlStr仅在设AFHTTPSessionManager时有用
 */

+(void)setCommonHeader:(id )obj url:(NSString *)urlStr;

/**
 * AFHTTPSessionManager设置请求头 主要用于广告
 */
+ (void)setHttpHeader:(AFHTTPSessionManager *)manager;

@end
