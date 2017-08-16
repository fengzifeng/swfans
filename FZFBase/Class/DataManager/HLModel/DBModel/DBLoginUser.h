//
//  DBLoginUser.h
//  MCFriends
//
//  Created by 马汝军 on 15/7/19.
//  Copyright (c) 2015年 marujun. All rights reserved.
//

#import "DBBaseUser.h"

@interface DBLoginUser : DBBaseUser

@property (nonatomic, assign) BOOL vip;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain, readonly) NSString * session_key;

- (void)synchronize;

@end
