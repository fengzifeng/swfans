//
//  DBBaseUser.h
//  MCFriends
//
//  Created by 马汝军 on 15/7/19.
//  Copyright (c) 2015年 marujun. All rights reserved.
//

#import "DBObject.h"

@interface DBBaseUser : DBObject

@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSString * birthday;
@property (nonatomic, retain) NSMutableDictionary * extra;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, assign) GENDER gender;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSString * signature;
@property (nonatomic, retain) NSString * photoNumber;

@end
