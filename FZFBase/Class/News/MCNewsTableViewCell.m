//
//  MCNewsTableViewCell.m
//  FZFBase
//
//  Created by fengzifeng on 16/7/11.
//  Copyright © 2016年 fengzifeng. All rights reserved.
//

#import "MCNewsTableViewCell.h"

@implementation MCNewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _contentLabel.numberOfLines = 2;
    
}

- (void)updateCell
{
    _contentLabel.text = @"对肌肤都能看见你那都是苏丹诺夫是你健康妇女狂放不羁基本款罗塞蒂尼开始你就开始东方男科奶粉";
    _iconLabel.text = @"今日头条";
    _timeLabel.text = @"1小时前";

}

@end

@implementation NewsCell

@end

@implementation ImagesCell

@end

@implementation TopImageCell
- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

@end

@implementation TopTxtCell

@end

@implementation BigImageCell

@end

