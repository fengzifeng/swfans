//
//  MCAboutMeCell.m
//  FZFBase
//
//  Created by fengzifeng on 16/7/7.
//  Copyright © 2016年 fengzifeng. All rights reserved.
//

#import "FFAboutMeCell.h"

@implementation FFAboutMeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_lineLabel autoSetDimension:ALDimensionHeight toSize:0.5];
}


- (void)updateCell:(NSString *)titleStr
{
    _titleLabel.text = titleStr;
    if ([titleStr isEqualToString:@"退出登录"]) {
        _contLabel.hidden = YES;
    } else {
        _contLabel.hidden = NO;;

    }
}


@end
