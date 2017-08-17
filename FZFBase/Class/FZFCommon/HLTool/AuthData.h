//
//  AuthData.h
//  HLMagic
//
//  Created by marujun on 14-1-8.
//  Copyright (c) 2014年 chen ying. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UserFilePath  [DocumentPath stringByAppendingPathComponent:(_loginUser.uid?:@"0")]

@interface AuthData : NSData

+ (FFLoginUser *)loginUser;

+ (void)removeLoginUser;

+ (void)synchronize;
+ (void)loginSuccess:(NSDictionary *)info;

@end
