//
//  FFActivityListCell.m
//  FZFBase
//
//  Created by 冯子丰 on 2017/8/22.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import "FFActivityListCell.h"
#import "FFActivityModel.h"

@implementation FFActivityListCell

- (void)awakeFromNib {
    [super awakeFromNib];

    _upImaegView.image = [_upImaegView.image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 7, -5)];
}

- (void)updateCell:(FFActivityItemModel *)model
{
    [_picImageView sd_setImageWithURL:[NSURL URLWithString:model.banner]];
//    _peopleCount.text = model
    _replyCount.text = [NSString stringWithFormat:@"评论 %@",model.replies];
    CGFloat width = [_replyCount.text stringWidthWithFont:_replyCount.font height:_replyCount.height] + 2;
    [_replyCount autoSetDimension:ALDimensionWidth toSize:width];
}

@end
