//
//  FFPostDetailCell.m
//  FZFBase
//
//  Created by fengzifeng on 2017/8/24.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import "FFPostDetailCell.h"
#import "ZYPAttributeLabel.h"
#import "FFPostModel.h"
#import "FFPostDetailViewController.h"

@implementation FFPostDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _contLabel.isHtml = YES;

}

- (void)updateCell:(FFPostItemModel *)model
{
    _contLabel.textcolor = HexColor(0x5a5a5a);
    _contLabel.textfont = [UIFont systemFontOfSize:14];
    _contLabel.text1 = model.message;
    [_contLabel autoSetDimension:ALDimensionHeight toSize:model.contentHeight];

}

+ (CGFloat)getCellHeight:(FFPostItemModel *)model
{

    CGFloat height = 70;
    ZYPAttributeLabel *label = [[ZYPAttributeLabel alloc] init];
    label.isHtml = YES;
    CGSize size;
    if (model.message.length) size = [label sizeWithWidth:SCREEN_WIDTH - 20 attstr:model.message textFont:[UIFont systemFontOfSize:14]];
    
    if (model.isComment) {
        height += size.height + 12;
    } else {
        height += size.height + 52;
    }
    
    return height;
}

- (IBAction)clickPost:(id)sender
{
    [((FFPostDetailViewController *)self.nearsetViewController).boardView.textView becomeFirstResponder];
}
@end
