//
//  FFLoginUser.h
//  FZFBase
//
//  Created by fengzifeng on 2017/8/17.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFLoginUser : NSObject

@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSString * birthday;
@property (nonatomic, retain) NSMutableDictionary * extra;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, assign) GENDER gender;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSString * signature;
@property (nonatomic, retain) NSString * photoNumber;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * password;



- (void)synchronize;

@end
