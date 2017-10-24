//
//  FFActivityModel.h
//  FZFBase
//
//  Created by 冯子丰 on 2017/8/31.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFActivityModel : NSObject

@property (nonatomic, strong) NSArray *data;

@end

@interface FFActivityItemModel : NSObject

@property (nonatomic, copy) NSString *tid;
@property (nonatomic, copy) NSString *fid;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *replies;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *authorid;
@property (nonatomic, copy) NSString *dateline;
@property (nonatomic, copy) NSString *banner;
@property (nonatomic, copy) NSString *forumName;
@property (nonatomic, copy) NSString *userImagePath;

@end
