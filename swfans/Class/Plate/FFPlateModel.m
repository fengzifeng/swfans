//
//  FFPlateModel.m
//  FZFBase
//
//  Created by fengzifeng on 2017/8/31.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import "FFPlateModel.h"

@implementation FFPlateModel

- (NSDictionary *)objectClassInArray
{
    return @{@"data" : [FFPlateSectionModel class]};
}

@end

@implementation FFPlateSectionModel

- (NSDictionary *)objectClassInArray
{
    return @{@"forums" : [FFPlateItemModel class]};
}

- (void)setName:(NSString *)name
{
    _name = [[name componentsSeparatedByString:@" "] lastObject];
}

@end

@implementation FFPlateItemModel

- (void)setName:(NSString *)name
{
    _name = name;
    self.oriName = name;
    self.upName = [[name componentsSeparatedByString:@" "] firstObject];

    if ([name rangeOfString:@" "].length) {
        self.downName = [[name componentsSeparatedByString:@" "] lastObject];
    }
}

- (void)setHeight:(CGFloat)height
{
    if (self.downName.length) {
        _height = 115;
    } else {
        _height = 100;
    }
}


@end
