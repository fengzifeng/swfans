//
//  FFPostDetailCell.m
//  FZFBase
//
//  Created by fengzifeng on 2017/8/24.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import "FFPostDetailCell.h"
#import "ZYPAttributeLabel.h"

@implementation FFPostDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateCell
{
    _contLabel.textcolor = HexColor(0x5a5a5a);
    _contLabel.textfont = [UIFont systemFontOfSize:14];

    _contLabel.text1 = @"你的苦难福克斯地方开始疯狂妇女卡萨诺疯狂胜负难料卡释放能量快；你是否开始你发开始";
}

+ (CGFloat)getCellHeight
{
    CGFloat height = 70;
    ZYPAttributeLabel *label = [[ZYPAttributeLabel alloc] init];
    label.isHtml = YES;
    CGSize size;
    size = [label sizeWithWidth:SCREEN_WIDTH - 20 attstr:@"你的苦难福克斯地方开始疯狂妇女卡萨诺疯狂胜负难料卡释放能量快；你是否开始你发开始" textFont:[UIFont systemFontOfSize:14]];
    height += size.height + 68;
    
    return height;
}
@end
