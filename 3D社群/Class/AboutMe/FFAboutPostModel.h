//
//  FFAboutPostModel.h
//  swfans
//
//  Created by fengzifeng on 2017/9/21.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFAboutPostModel : NSObject

@property (nonatomic, strong) NSArray *data;

@end

@interface FFAboutPostItemModel : NSObject

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

@end
