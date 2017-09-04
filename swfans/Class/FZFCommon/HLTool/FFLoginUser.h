//
//  FFLoginUser.h
//  FZFBase
//
//  Created by fengzifeng on 2017/8/17.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFLoginUser : NSObject

@property (nonatomic, retain) NSString * posts;
@property (nonatomic, retain) NSString * friends;
@property (nonatomic, retain) NSMutableDictionary * extra;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, assign) GENDER gender;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSString * signCode;
@property (nonatomic, retain) NSString * profile;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * threads;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * prestige;
@property (nonatomic, retain) NSString * money;
@property (nonatomic, retain) NSString * point;
@property (nonatomic, retain) NSString * status;


- (void)synchronize;

@end
