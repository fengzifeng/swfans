//
//  MCAboutMeCell.m
//  FZFBase
//
//  Created by fengzifeng on 16/7/7.
//  Copyright © 2016年 fengzifeng. All rights reserved.
//

#import "MCAboutMeCell.h"

@implementation MCAboutMeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_lineLabel autoSetDimension:ALDimensionHeight toSize:0.5];
}


- (void)updateCell:(NSString *)titleStr
{
    _titleLabel.text = titleStr;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
