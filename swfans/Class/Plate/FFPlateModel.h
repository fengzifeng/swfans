//
//  FFPlateModel.h
//  FZFBase
//
//  Created by fengzifeng on 2017/8/31.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface FFPlateModel : NSObject

@property (nonatomic, strong) NSArray *data;

@end


@interface FFPlateSectionModel : NSObject

@property (nonatomic, copy) NSString *fid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *forums;

@end

@interface FFPlateItemModel : NSObject

@property (nonatomic, copy) NSString *fid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, copy) NSString *upName;
@property (nonatomic, copy) NSString *downName;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy) NSString *oriName;



@end
