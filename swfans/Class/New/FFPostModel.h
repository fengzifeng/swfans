//
//  FFPostModel.h
//  swfans
//
//  Created by fengzifeng on 2017/9/2.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFPostModel : NSObject

@property (nonatomic, strong) NSArray *data;

@end

@interface FFPostItemModel : NSObject

@property (nonatomic, copy) NSString *fid;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *replies;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *authorid;
@property (nonatomic, copy) NSString *dateline;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *userImagePath;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) BOOL isComment;
@property (nonatomic, assign) CGFloat contentHeight;

@end
