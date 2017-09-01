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
    // Initialization code
}

- (void)updateCell:(FFActivityItemModel *)model
{
    [_picImageView sd_setImageWithURL:[NSURL URLWithString:model.banner]];
//    _peopleCount.text = model

}
@end
