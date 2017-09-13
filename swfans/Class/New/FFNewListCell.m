//
//  FFNewListCell.m
//  FZFBase
//
//  Created by fengzifeng on 2017/8/16.
//  Copyright © 2017年 fengzifeng. All rights reserved.
//

#import "FFNewListCell.h"
#import "FFNewListModel.h"

@interface FFNewListCell ()
{
    FFNewListItemModel*_currentModel;
}

@end

@implementation FFNewListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _upImaegView.image = [_upImaegView.image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 7, -5)];


}

- (void)updateCell:(FFNewListItemModel *)model
{
    _currentModel = model;
    _faceButton.layer.masksToBounds = YES;
    _faceButton.layer.cornerRadius = 10;
    [_faceButton sd_setImageWithURL:[NSURL URLWithString:model.userImagePath] forState:UIControlStateNormal];
    _nameLabel.text = model.author;
    [_typeLabel setTitle:model.forumName forState:UIControlStateNormal];
    _upLabel.text = model.subject;
    NSString *str = [HLTool timeInfoWithDateString:model.dateline];
    _timeLabel.text = str;
    _replyLabel.text =  [NSString stringWithFormat:@"评论 %@",model.replies];
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    if (!_currentModel) return;
    
    CGFloat typeWidth = [_currentModel.forumName stringWidthWithFont:_typeLabel.titleLabel.font height:11] + 3;
    [_typeLabel autoSetDimension:ALDimensionWidth toSize:typeWidth];
//    CGFloat replyWidth = [_replyLabel.text stringWidthWithFont:_replyLabel.font height:11] + 2;
//    [_replyLabel autoSetDimension:ALDimensionWidth toSize:replyWidth];
    [_upLabel autoSetDimension:ALDimensionHeight toSize:_currentModel.height - 70];
}


- (IBAction)clcikType:(id)sender
{

}

@end
