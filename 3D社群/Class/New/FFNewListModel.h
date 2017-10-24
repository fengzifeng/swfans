//
//  FFNewListModel.h
//  FZFBase
//
//  Created by fengzifeng on 2017/8/17.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import "FFNewListModel.h"

@interface FFNewListModel : NSObject

@property (nonatomic, strong) NSArray *data;

@end

@interface FFNewListItemModel : NSObject

@property (nonatomic, copy) NSString *fid;
@property (nonatomic, copy) NSString *tid;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *replies;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *authorid;
@property (nonatomic, copy) NSString *dateline;
@property (nonatomic, copy) NSString *forumName;
@property (nonatomic, copy) NSString *userImagePath;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *pid;


@end
