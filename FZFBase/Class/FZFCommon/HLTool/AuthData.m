//
//  AuthData.m
//  HLMagic
//
//  Created by marujun on 14-1-8.
//  Copyright (c) 2014年 chen ying. All rights reserved.
//

#import "AuthData.h"
#import "FFLoginUser.h"

static FFLoginUser *loginUser;

@implementation AuthData

+ (FFLoginUser *)loginUser
{
    if (!loginUser) {
        NSDictionary *info = [userDefaults objectForKey:UserDefaultKey_LoginUser];
        if (info) {
            loginUser = [FFLoginUser objectWithKeyValues:info];
        }
    }
    return loginUser;
}

+ (void)removeLoginUser
{
    //取消别名
    loginUser = nil;
    [self synchronize];
    
}

+ (void)loginSuccess:(NSDictionary *)info
{
    
    loginUser = [FFLoginUser objectWithKeyValues:info];
    [self synchronize];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:UserFilePath isDirectory:nil]) {
        [fileManager createDirectoryAtPath:UserFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //通知其他页面刷新数据
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_LoginSuccess object:nil];
    
}

+ (void)synchronize
{
    if (loginUser) {
        [userDefaults setObject:[loginUser keyValues] forKey:UserDefaultKey_LoginUser];
    } else {
        [userDefaults removeObjectForKey:UserDefaultKey_LoginUser];
    }
    
    [userDefaults synchronize];
}


@end
