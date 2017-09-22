//
//  MCLog.h
//  MCLog
//
//  Created by fengzifeng on 15/3/26.
//  Copyright (c) 2015年 fengzifeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    log_level_error    = 1,
    log_level_warning  = 2,
    log_level_info     = 3,
    log_level_debug    = 4
} LogLevel;

#define DLOG(...) NSLog(@"%@",[NSString stringWithFormat:__VA_ARGS__])
#define ELOG(...) NSLog(@"%@",[NSString stringWithFormat:__VA_ARGS__])
#define FLOG(...) NSLog(@"%@",[NSString stringWithFormat:__VA_ARGS__])
#define WLOG(...) NSLog(@"%@",[NSString stringWithFormat:__VA_ARGS__])

@interface MCLog : NSObject

/*!
 @property
 @brief 是否是debug模式，如果是debug模式则默认打印DEBUG级别日志，并且setLogLevel方法将失效
 */
@property (nonatomic, assign) BOOL is_debug;

/*!
 @method
 @brief 获取单例对象
 */
+ (instancetype)defaultManager;

/*!
 @method
 @param uid 用户的uid
 @param token 用户的token
 @brief 注册用户，按用户分别上传日志
 */
- (void)registerUser:(NSString *)uid token:(NSString *)token;

/*!
 @method
 @param level 日志级别
 @brief 设置日志级别
 */
- (void)setLogLevel:(int)level;

/*!
 @method
 @param domain 上传服务器的的域名 如：192.168.1.1:8080
 @brief 开始上传日志
 */
- (void)upload:(NSString *)domain;

/*!
 @method
 @param level  日志级别
 @param file   文件名  可使用宏：__FILE__
 @param line   行数   可使用宏：__LINE__
 @brief 打印日志
 */
- (void)logWithType:(LogLevel)level file:(const char *)file line:(int)line string:(NSString *)string;

@end
